# Walkthrough from https://blog.pusher.com/websockets-from-scratch/

load "websocket_connection.rb"
load "websocket_server.rb"

server = WebSocketServer.new

loop do
  Thread.new(server.accept) do |connection|
    puts "Connected"
    while (message = connection.recv)
      puts "Received #{message} from the client"
      connection.send("Received #{message}. Thanks!")
    end
  end
end
