require 'spec_helper'
require 'amqp_rpc/client/caller'

describe AmqpRpc::Client::Caller do
  let(:config) { double('config', endpoint: 'endpoint') }
  let(:callee) { described_class.new(config) }

  before do
    bunny = spy('bunny')
    allow(Bunny).to receive(:new)
      .with(automatically_recover: false).and_return(bunny)
    allow(Mutex).to receive(:new)
    allow(ConditionVariable).to receive(:new)
  end

  it '#call' do
    expect(callee).to receive(:generate_uuid).and_return('hi')
    expect(callee).to receive(:call_server).with('data')

    mutex = double('mutex')
    expect(mutex).to receive(:synchronize).and_yield

    resource = instance_spy('ConditionVariable')
    callee.instance_variable_set(:@semaphore, mutex)
    callee.instance_variable_set(:@resource, resource)

    expect(callee.call('data')).to eq(callee)
    expect(callee.instance_variable_get(:@call_id)).to eq('hi')
    expect(resource).to have_received(:wait).with(mutex)
  end

  it '#close' do
    channel = double
    conn = double
    expect(channel).to receive(:close)
    expect(conn).to receive(:close)
    callee.instance_variable_set(:@ch, channel)
    callee.instance_variable_set(:@conn, conn)
    expect(callee.close).to eq(callee)
  end

  it '#call_server' do
    exchange = double
    expect(exchange).to receive(:publish)
      .with('data', routing_key: 'endpoint',
                    correlation_id: 'call_id',
                    reply_to: 'reply_queue.name')
    callee.instance_variable_set(:@call_id, 'call_id')
    callee.instance_variable_set(:@reply_queue,
                                 double(name: 'reply_queue.name'))
    callee.instance_variable_set(:@exchange, exchange)
    callee.send(:call_server, 'data')
  end

  it '#subscribe_to_reply_queue' do
    reply_queue = double
    allow(reply_queue).to receive(:subscribe)
      .and_yield('', { correlation_id: 'call_id' }, 'payload')
    callee.instance_variable_set(:@reply_queue, reply_queue)
    expect(callee).to receive(:set_response).with('call_id', 'payload')
    callee.send(:subscribe_to_reply_queue)
  end

  describe '#set_response' do
    it 'has same call_id' do
      callee.instance_variable_set(:@call_id, 'not_equal')
      callee.send(:set_response, 'equal', 'response')
      expect(callee.instance_variable_get(:@response)).to_not eq('response')
    end

    it 'sets respond instance var and releases semaphore' do
      callee.instance_variable_set(:@call_id, 'equal')

      mutex = double('mutex')
      expect(mutex).to receive(:synchronize).and_yield
      resource = instance_spy('ConditionVariable')
      callee.instance_variable_set(:@semaphore, mutex)
      callee.instance_variable_set(:@resource, resource)

      callee.send(:set_response, 'equal', 'response')
      expect(resource).to have_received(:signal)
      expect(callee.instance_variable_get(:@response)).to eq('response')
    end
  end

  it '#generate_uuid' do
    expect(callee.send(:generate_uuid)).to_not eq(callee.send(:generate_uuid))
  end
end
