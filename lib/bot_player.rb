require 'socket'
require_relative 'socket_client'
client = SocketClient.new(3336)

loop do
    server_message = ""
    until server_message != ""
        server_message = client.read_message
    end
    puts server_message
    if server_message.include?('What') || server_message.include?('enter')
        client.send_message(gets.chomp)
    end
end