require "./redis-protocol/*"

module RedisProtocol
  def self.parse(buf)
    RedisProtocol::Parser.parse(buf)
  end
end
