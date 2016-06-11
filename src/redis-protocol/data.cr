module RedisProtocol
  record RespParsed,
    op   : Char,
    args : Array(String)

  record RedisInteger,
    raw : Int32 do

    def value
      raw
    end

    def to_s(io : IO)
      io << "#{value}"
    end
  end

  record RedisString,
    raw : String do

    def value
      raw
    end

    def to_s(io : IO)
      io << value.inspect
    end
  end

  class RedisNullInstance
    def value
      nil
    end

    def to_s(io : IO)
      io << "(nil)"
    end

    def inspect(io : IO)
      io << "RedisProtocol::RedisNull"
    end
  end
  RedisNull = RedisNullInstance.new # as Singleton

  record RedisError,
    raw : String do

    def value
      raw
    end

    def to_s(io : IO)
      io << "Error(#{value})"
    end
  end

  alias Type = RedisInteger | RedisString | RedisError | RedisNull
  
  record RedisArray,
    raw : Array(Type) do

    def value
      raw.map(&.value)
    end

    def to_s(io : IO)
      io << "["
      raw.each_with_index do |v,i|
        io << v.to_s
        io << ", " if i < raw.size - 1
      end
      io << "]"
    end
  end
end
