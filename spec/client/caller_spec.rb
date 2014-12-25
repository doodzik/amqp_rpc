require 'spec_helper'
require 'amqp_rpc/client/caller'

describe AmqpRpc::Client::Caller do
  before do
    bunny = spy('bunny')
    allow(Bunny).to receive(:new).with(automatically_recover: false).and_return(bunny)
  end

  it '#new' do
    skip
  end

  it '#call' do
    skip
  end

  it '#close' do
    skip
  end

  it '#call_server' do
    skip
  end

  it '#subscribe_to_reply_queue' do
    skip
  end

  it '#set_response' do
    skip
  end

  it '#generate_uuid' do
    skip
  end
end
