require 'spec_helper'
require 'amqp_rpc/server/caller'

describe AmqpRpc::Server::Caller do
  let(:config) { double('config', endpoint: 'endpoint') }
  let(:callee) { described_class.new(config) }

  before do
    bunny = spy('bunny')
    allow(Bunny).to receive(:new).and_return(bunny)
  end

  describe '#call' do
    it 'calls block' do
      block = proc { 'hi' }
      expect(callee).to receive(:start) { |&arg| expect(arg.call).to eq('hi') }
      callee.call(&block)
    end

    it 'rescues Interuped' do
      block = proc {}
      allow(callee).to receive(:start).and_raise(Interrupt)
      expect(callee).to receive(:close)
      callee.call(&block)
    end
  end

  it '#close' do
    channel = double
    conn = double
    expect(channel).to receive(:close)
    expect(conn).to receive(:close)
    callee.instance_variable_set(:@ch, channel)
    callee.instance_variable_set(:@conn, conn)
    callee.send :close
  end

  it '#start' do
    queue    = double
    exchange = double
    payload = 'data'
    expect(payload).to receive(:to_s).and_return(payload)
    property = double reply_to: 'reply_to', correlation_id: 'corr_id'

    expect(queue).to receive(:subscribe)
      .with(block: true).and_yield(nil, property, 'data')
    expect(exchange).to receive(:publish)
      .with('data', routing_key: 'reply_to', correlation_id: 'corr_id')

    callee.instance_variable_set(:@x, exchange)
    callee.instance_variable_set(:@q, queue)

    callee.send(:start) do |data|
      expect(data).to eq('data')
      payload
    end
  end
end
