
MuxDemux = require 'mux-demux/msgpack'
net = require 'net'
uuid = require 'node-uuid'

PORT = 8642

server  = net.createServer (con) ->
  mx = MuxDemux()
  con.pipe(mx).pipe(con)
  messages = mx.createWriteStream('messages')

  proxyServer = net.createServer (clientProxy) ->
    serverProxy = mx.createStream(uuid.v4())
    clientProxy.pipe(serverProxy).pipe(clientProxy)

  proxyServer.listen ->
    address = proxyServer.address()
    console.log("opened server on %j", address)
    messages.write "port=#{address.port}\n"

server.listen PORT, ->
  console.log "Freebird server listening on", server.address()
