require 'spec_helper'
require 'amqp_rpc/server'

describe AmqpRpc::Server do
  context 'when extended' do
    # test integration of the client
    class Test
      extend AmqpRpc::Server
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
        extend AmqpRpc::Server
        config do |c|
          c.endpoint = 'Test'
        end
      end
    end
    expect(Test1::Foo.instance_variable_get(:@config).endpoint)
      .to eql 'Test'
  end

  it '.call' do
    # implementation mock
    class Test2
      extend AmqpRpc::Server
    end
    callee = double
    expect(Test2).to receive(:call_method).with('data')
    expect(callee).to receive(:call).and_yield('data')
    allow(described_class::Caller).to receive(:new).and_return(callee)
    Test2.call
  end

  it '.call_method' do
    # implementation mock
    class Test3
      extend AmqpRpc::Server

      def self.example(a)
        a
      end
    end
    handler = instance_double 'DataHandler', f: 'example', a: 2
    expect(handler).to receive(:r=).with(2)
    expect(AmqpRpc::DataHandler).to receive(:new)
      .with(data: 'data').and_return(handler)
    expect(Test3.send :call_method, data: 'data')
      .to eq(handler)
  end
end
