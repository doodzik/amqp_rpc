require "bunny"
require 'msgpack'

module AmqpRpc
  module Server
    class Caller

      def initialize(config, ch)
        @config = config
        @conn   = Bunny.new.start
        @ch     = @conn.create_channeli
        @q      = @ch.queue(@config.endpoint)
        @x      = @ch.default_exchange
      end

      def call(&block)
        start &block
      rescue Interrupt => _
        close
      end

      private

      def close
        @ch.close
        @conn.close
      end

      def start
        @q.subscribe(:block => true) do |delivery_info, properties, payload|
          data = yield(data)
          @x.publish(data.to_s, :routing_key => properties.reply_to, :correlation_id => properties.correlation_id)
        end
      end
    end
  end
end


