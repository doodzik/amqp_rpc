require 'spec_helper'
require 'msgpack'
require 'amqp_rpc/data_handler'

describe AmqpRpc::DataHandler do
  it 'converts it to msgpack when to_s is send' do
    data = described_class.new({ bar: 'foo' }.to_msgpack)
    data.foo = 'bar'
    expect(data.to_s).to eq({ bar: 'foo', foo: 'bar' }.to_msgpack)
  end
end
