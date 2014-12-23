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
      this = self
      define_singleton_method name do |*args, &_block|
        type = this.send(name, *args).name.to_sym
        value = Caller.new(@config, *args).call.close.value
        Converter.call(type, value)
      end
    end

    # all the config is set in this class
    class Config
      attr_accessor :endpoint
    end

    # has all the AmqpRpc logic in it
    class Caller
      def initialize(*_args)
      end

      def call
        self
      end

      def close
        self
      end

      def value
        self
      end
    end

    # coverts the string with to the provided Type
    class Converter
      def self.call(_type, _value)
        nil
      end
    end
  end
end
