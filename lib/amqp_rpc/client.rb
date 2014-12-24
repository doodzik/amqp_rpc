require 'amqp_rpc/client/config'
require 'amqp_rpc/client/caller'
require 'msgpack'

module AmqpRpc
  # client for making rpc calls
  module Client
    def self.extended(base)
      config = Config.new
      config.endpoint = base.name
      base.instance_variable_set(:@config, config)
    end

    def config
      yield(@config)
    end

    def method_added(name)
      define_singleton_method name do |*args, &_block|
        value = Caller.new(@config, *args).call.close.value
        MessagePack.unpack(value)
      end
    end
  end
end
