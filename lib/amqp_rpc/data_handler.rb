require 'msgpack'
require 'ostruct'

module AmqpRpc
  class DataHandler < OpenStruct
    def initialize(data)
      data = MessagePack.unpack(data)
      super(data)
    end

    def to_s
      @table.to_msgpack
    end
  end
end
