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

    # all the config is set in this class
    class Config
      attr_accessor :endpoint
    end
  end
end
