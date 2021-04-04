require "base64"
require "digest/sha1"
require "logger"
require "socket"

require 'pry'

class WebSocketServer
  # See https://tools.ietf.org/html/rfc6455#page-60
  WS_MAGIC_STRING = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

  def initialize(path: "/", port: 4567, host: "localhost")
    @path = path
    @port = port
    @host = host

    # New TCP Server that does nothing until you call `accept`
    @tcp_server = TCPServer.new(host, port)
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  def accept
    socket = @tcp_server.accept
    send_handshake(socket) or return

    return WebSocketConnection.new(socket)
  end

  private

  def send_handshake(socket)
    logger.debug("Sending handshake on #{socket}")

    request_line = socket.gets
    header = get_header(socket)

    logger.debug("Request line: #{request_line}")
    logger.debug("Header: #{header}")

    if (request_line =~ /GET #{@path} HTTP\/1.1/) && (header =~ /Sec-WebSocket-Key: (.*)\r\n/)
      ws_accept = create_websocket_accept($1)
      send_handshake_response(socket, ws_accept)
      return true
    end

    send_400(socket)
    return false
  end

  def get_header(socket, header = "")
    line = socket.gets
    line == "\r\n" ? header : get_header(socket, header + line)
  end

  def create_websocket_accept(key)
    digest = Digest::SHA1.digest(key + WS_MAGIC_STRING)
    return Base64.encode64(digest)
  end

  def send_handshake_response(socket, ws_accept)
    logger.debug("Accept")

    socket << "HTTP/1.1 101 Switching Protocols\r\n" \
      "Upgrade: websocket\r\n" \
      "Connection: Upgrade\r\n" \
      "Sec-WebSocket-Accept: #{ws_accept}\r\n"
  end

  def send_400(socket)
    logger.debug("Sending 400")

    socket << "HTTP/1.1 400 Bad Request\r\n" \
      "Content-Type: text/plain\r\n" \
      "\r\n" \
      "Incorrect Request"
    socket.close
  end
end
