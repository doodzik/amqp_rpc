module AmqpRpc
  module Client
    # all the config is set in this class
    class Config
      def method_missing(method, *args, &block)
        ms = method.to_s
        method_t = (ms =~ /^(.*)=$/)? ms[0...-1] : ms
        self.class.send(:attr_accessor, method_t.to_s)
        send(method, args)
      end
    end
  end
end
