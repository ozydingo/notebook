## Essential operations

* `set KEY VALUE`
* `get KEY`
* `exists KEY` => 0/1
* `del KEY [...KEYS]`

## Atomic Power

* `getdel KEY`
* `getset KEY NEWVALUE`
* `rpoplpush SOURCE DEST`
* `lmove SOURCE DEST`

## Counters

* `incr KEY`
* `decr KEY`
* `incrby KEY NUM`
* `decrby KEY NUM`

## Expiration

* `expire KEY SECONDS`
* `pexpire KEY MILLISECONDS`
* `TTL KEY` => seconds; -1 for no expirration, -2 for does not exist
* `PTTL KEY` => milliseconds

Expired keys have `del` performed on them.

Cancel an expiration using

* `persist KEY` // Cancel a pending expiration
* `set KEY ex SECONDS`

## Lists

* `lpush KEY VALUE [...VALUES]` => length
* `lpop KEY`
* `llen KEY`
* `lrange KEY START END` // END is inclusive
* `rpush KEY VALUE [...VALUES]`
* `rpop KEY`

## Sets

* `sadd KEY VALUE [...VALUES]` => # elements added (not already present)
* `srem KEY VALUE [...VALUES]` => # elements removed
* `smembers KEY`
* `sismembers KEY VALUE`
* `sunion SET1 SET2 [...SETS]`
* `spop KEY NUM` => don't depend on order
* `srandmember KEY NUM` => sample NUM members. Use -NUM for with-replacement.

## Sorted Sets

* `zadd KEY SCROE VALUE [...SCORE VALUE...]`
* `zrange KEY START END [withscores]`

# Hashes

* `hset KEY FIELD VALUE [...FIELD VALUE...]`
* `hget KEY FIELD`
* `hdel KEY FIELD`
* `hincryby KEY FIELD NUM`
