require 'bunny'
require 'thread'
require 'SecureRandom'

module AmqpRpc
  module Client
    # has all the AmqpRpc logic in it
    class Caller
      attr_reader :response

      def initialize(config)
        @config         = config
        @conn           = Bunny.new(automatically_recover: false).start
        @ch             = @conn.create_channel
        @exchange       = @ch.default_exchange
        @reply_queue    = @ch.queue('', exclusive: true)
        @semaphore      = Mutex.new
        @resource       = ConditionVariable.new

        subscribe_to_reply_queue
      end

      def call(data_to_send)
        @call_id = generate_uuid
        call_server(data_to_send)
        @semaphore.synchronize { @resource.wait(@semaphore) }
        self
      end

      def close
        @ch.close
        @conn.close
        self
      end

      private

      def call_server(data_to_send)
        @exchange.publish(data_to_send,
                          routing_key:    @config.endpoint,
                          correlation_id: @call_id,
                          reply_to:       @reply_queue.name)
      end

      def subscribe_to_reply_queue
        @reply_queue.subscribe do |_delivery_info, properties, payload|
          set_response properties[:correlation_id], payload
        end
      end

      def set_response(call_id, response)
        return unless call_id == @call_id
        @response = response
        @semaphore.synchronize { @resource.signal }
      end

      # generates random string
      # @return [String]
      def generate_uuid
        SecureRandom.urlsafe_base64(nil, false)
      end
    end
  end
end
