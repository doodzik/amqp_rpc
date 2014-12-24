require 'spec_helper'
require 'amqp_rpc/client/caller'

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
