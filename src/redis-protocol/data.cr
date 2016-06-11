module RedisProtocol
  record RespParsed,
    op   : Char,
    args : Array(String)

  record RedisInteger,
    raw : Int32 do

    def value
      raw
    end
  end

  record RedisString,
    raw : String do

    def value
      raw
    end
  end

  class RedisNullInstance
    def value
      nil
    end
  end
  RedisNull = RedisNullInstance.new # as Singleton

  record RedisError,
    raw : String do

    def value
      raw
    end
  end

  alias Type = RedisInteger | RedisString | RedisError | RedisNull
  
  record RedisArray,
    raw : Array(Type) do

    def value
      raw.map(&.value)
    end
  end
end
