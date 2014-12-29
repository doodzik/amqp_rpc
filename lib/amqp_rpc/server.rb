require 'amqp_rpc/config'
require 'amqp_rpc/server/caller'
require 'amqp_rpc/data_handler'
require 'msgpack'

module AmqpRpc
  # client for making rpc calls
  module Server
    def self.extended(base)
      config = Client::Config.new
      config.endpoint = base.name
      base.instance_variable_set(:@config, config)
    end

    def config
      yield(@config)
    end

    def call
      Caller.new(config).call { |data| call_method(data) }
    end

    private

    def call_method(data)
      handler = DataHandler.new(data)
      handler.return = send handler.func, handler.args
      handler
    end
  end
end

