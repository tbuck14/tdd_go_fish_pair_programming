require 'socket'
require_relative 'socket_client'
client = SocketClient.new(3336)
NAME = 'dumb_bot'
client.send_message(NAME + rand(999).to_s)
loop do
    server_message = ""
    until server_message != ""
        server_message = client.read_message
    end
    puts server_message
    if server_message.include?('What player')
        other_players = server_message.split(': ').last[1..-2].split(', ')
        client.send_message(other_players[rand(other_players.count)][1..-2])
    elsif server_message.include?('What card') 
        cards_availble = server_message.split(': ').last[1..-2].split(', ')
        client.send_message(cards_availble[rand(cards_availble.count)][1..-2])
    end
end