module RedisProtocol::Parser
  DELIMITER="\r\n"

  class ParseError < Exception; end

  def error(msg)
    raise ParseError.new("#{msg}")
  end

  def parse(data)
    # data: "*1\r\n$4\r\nping"
    resp = extract(data)
    case resp.op
    when '*'
      parse_array resp
    else
      parse_primitive resp
    end
  end
  
  def parse_primitive(resp)
    case resp.op
    when '$'
      parse_bulk_string resp
    when '+'
      parse_simple_string resp
    when '-'
      parse_error resp
    when ':'
      parse_integer resp
    else
      error "unknown protocol: #{resp.op}"
    end
  end

  def parse_array(resp)
    # data: "*2\r\n$4\r\nkeys\r\n$1\r\n*\r\n"
    # resp.args: ["2", "$4", "keys", "$1", "*"]
    #  -> ["keys", "*"]

    size = resp.args.shift # drop "size"
    vals = resp.args.in_groups_of(2).map{|a|
      parse_primitive(extract(a.join(DELIMITER)))
    }
    
    RedisProtocol::RedisArray.new(vals)
  end

  def parse_bulk_string(resp)
    if resp.args[0] == "-1"
      RedisProtocol::RedisNull
    else
      RedisProtocol::RedisString.new(resp.args[1])
    end
  end

  def parse_simple_string(resp)
    RedisProtocol::RedisString.new(resp.args[0])
  end

  def parse_error(resp)
    RedisProtocol::RedisError.new(resp.args[0])
  end

  def parse_integer(resp)
    RedisProtocol::RedisInteger.new(resp.args[0].to_i)
  end

  private def extract(buf)
    error "empty data" if buf.empty?
    RespParsed.new(buf[0], String.new(buf.unsafe_byte_slice(1)).chomp.split(DELIMITER))
  end

  extend self
end
