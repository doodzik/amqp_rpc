require 'msgpack'
require 'ostruct'

module AmqpRpc
  # r is the return value
  # f is the function
  # a is a list of the args
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
