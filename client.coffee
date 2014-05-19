
MuxDemux = require 'mux-demux/msgpack'
net = require 'net'

FREEBIRD_HOST = "localhost"
FREEBIRD_PORT = 8642

LOCAL_PORT = parseInt(process.argv[2], 10)

con = net.connect FREEBIRD_PORT, FREEBIRD_HOST
mx = MuxDemux()
con.pipe(mx).pipe(con)

mx.on "connection", (stream) ->
  console.log "connection", stream.meta
  if stream.meta is "messages"
    stream.on "data", (message) ->
      console.log "message", message
  else
    id = stream.meta
    localProxy = net.connect LOCAL_PORT
    stream.pipe(localProxy).pipe(stream)
