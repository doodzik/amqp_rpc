require 'spec_helper'
require 'amqp_rpc/client'

describe AmqpRpc::Client do
  context 'when included' do
    # test integration of the client
    class Test
      extend AmqpRpc::Client
    end
    it 'sets endpoint name to classname' do
      expect(Test.instance_variable_get(:@config).endpoint).to eql 'Test'
    end
  end

  it 'has a config method' do
    # test integration of the client
    module Test1
      # example class name unimportant
      class Foo
        extend AmqpRpc::Client
        config do |c|
          c.endpoint = 'Test'
        end
      end
    end
    expect(Test1::Foo.instance_variable_get(:@config).endpoint)
      .to eql 'Test'
  end

  it '.method_added' do
    callee_value = instance_double('Caller', value: 'true')
    callee_close = instance_double('Caller', close: callee_value)
    callee = instance_double('Caller', call: callee_close)
    allow(Test).to receive(:send).and_return(String)
    allow(described_class::Caller).to receive(:new).and_return callee
    allow(described_class::Converter).to receive(:call)
      .with(:String, 'true').and_return('works')
    Test.method_added('fdfa')
    expect(Test.fdfa).to eql('works')
  end

  describe AmqpRpc::Client::Caller do
    it '#call' do
      instance = described_class.new
      expect(instance.call).to eq(instance)
    end

    it '#close' do
      instance = described_class.new
      expect(instance.close).to eq(instance)
    end

    it '#value' do
      instance = described_class.new
      expect(instance.value).to eq(instance)
    end
  end

  describe AmqpRpc::Client::Converter do
  end

  describe AmqpRpc::Client::Config do
  end
end
