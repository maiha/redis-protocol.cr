require "../spec_helper"

describe RedisProtocol::Parser do
  it "should parse a redis unified protocol based message" do
    result = RedisProtocol.parse "$4\r\nping"
    result.should eq(RedisProtocol::RedisString.new("ping"))
    result.value.should eq("ping")
  end

  it "should parse multi-chunked format" do
    result = RedisProtocol.parse "*1\r\n$4\r\nping"
    result.should be_a(RedisProtocol::RedisArray)
    result.value.should eq(["ping"])
    
    result = RedisProtocol.parse "*2\r\n$4\r\nkeys\r\n$1\r\n*\r\n"
    result.should be_a(RedisProtocol::RedisArray)
    result.value.should eq(["keys", "*"])
  end

  it "should parse status ok" do
    result = RedisProtocol.parse "+OK\r\n"
    result.should eq(RedisProtocol::RedisString.new("OK"))
    result.value.should eq("OK")
  end

  it "should parse error with message" do
    result = RedisProtocol.parse "-ERR unknown command 'foobar'\r\n"
    result.should eq(RedisProtocol::RedisError.new("ERR unknown command 'foobar'"))
    result.value.should eq("ERR unknown command 'foobar'")
  end

  it "should parse integer only return" do
    result = RedisProtocol.parse ":1000\r\n"
    result.should eq(RedisProtocol::RedisInteger.new(1000))
    result.value.should eq(1000)
  end

  it "should parse negative integer" do
    result = RedisProtocol.parse ":-30\r\n"
    result.should eq(RedisProtocol::RedisInteger.new(-30))
    result.value.should eq(-30)
  end

  it "should parse an empty string" do
    result = RedisProtocol.parse "$0\r\n\r\n"
    result.should eq(RedisProtocol::RedisString.new(""))
    result.value.should eq("")
  end

  it "should parse null" do
    result = RedisProtocol.parse "$-1\r\n"
    result.should eq(RedisProtocol::RedisNull)
    result.value.should eq(nil)
  end
end
