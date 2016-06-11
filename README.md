# redis-protocol.cr [![Build Status](https://travis-ci.org/maiha/redis-protocol.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-protocol.cr)

crystal support for "redis-protocol.rb"

- [Redis Protocol specification](http://redis.io/topics/protocol)
- [redis-protocol.rb](https://rubygems.org/gems/redis-protocol)

## TODO

- [x] RedisProtocol::Parse (0.1 ready)
- [ ] RedisProtocol::Request (maybe 0.2)
- [ ] RedisProtocol::Response (maybe 0.3)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  redis-protocol:
    github: maiha/redis-protocol.cr
```

## Usage

```crystal
require "redis-protocol"
```

### parse

#### RESP Simple Strings

```crystal
resp = RedisProtocol.parse("+OK\r\n")
p resp       # => RedisProtocol::RedisString(@raw="OK")
p resp.value # => "OK"
```

#### RESP Errors

```crystal
resp = RedisProtocol.parse("-Error message\r\n")
p resp       # => RedisProtocol::RedisError(@raw="Error message")
p resp.value # => "Error message"
```

#### RESP Integers

```crystal
resp = RedisProtocol.parse(":1000\r\n")
p resp       # => RedisProtocol::RedisInteger(@raw=1000)
p resp.value # => 1000
```

#### RESP BulkString

```crystal
resp = RedisProtocol.parse("$6\r\nfoobar\r\n")
p resp       # => RedisProtocol::RedisString(@raw="foobar")
p resp.value # => "foobar"
```

#### RESP Null

```crystal
resp = RedisProtocol.parse("$-1\r\n")
p resp       # => RedisProtocol::RedisNull()
p resp.value # => nil
```

#### RESP Array

```crystal
resp = RedisProtocol.parse("*2\r\n$4\r\nkeys\r\n$1\r\n*\r\n")
p resp       # => RedisProtocol::RedisArray(@raw=[RedisProtocol::RedisString(@raw="keys"), RedisProtocol::RedisString(@raw="*")])
p resp.value # => ["keys", "*"]
```

## Development


## Contributing

1. Fork it ( https://github.com/maiha/redis-protocol.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- https://github.com/maiha - creator, maintainer
