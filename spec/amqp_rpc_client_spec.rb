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
end
