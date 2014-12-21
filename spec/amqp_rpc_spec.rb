require 'spec_helper'
require 'amqp_rpc'

describe AmqpRpc do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'has amqp rpc client class' do
    expect(described_class.const_defined?(:Server)).to be true
  end

  it 'has amqp rpc server class' do
    expect(described_class.const_defined?(:Client)).to be true
  end
end
