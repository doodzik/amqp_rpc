require 'spec_helper'
require 'msgpack'
require 'amqp_rpc/client'

describe AmqpRpc::Client do
  context 'when extended' do
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
    callee_value = instance_double('Caller', response: { r: 'works' }.to_msgpack)
    callee_close = instance_double('Caller', close: callee_value)
    callee = instance_double('Caller', call: callee_close)
    allow(described_class::Caller).to receive(:new).and_return callee
    Test.method_added('fdfa')
    expect(Test.fdfa).to eql('works')
  end
end
