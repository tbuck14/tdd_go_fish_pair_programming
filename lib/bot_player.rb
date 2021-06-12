require 'socket'
require_relative 'socket_client'
client = SocketClient.new(3336)
ROBOT_NAMES = ['dd1','r2d2','zap','bolts','ddr4','killzone','robo','zany','bdot','shocker','buzz','boba','spaz','wal-e','c3p0','terminator','notbot','foxy','freddie','electro','titan','bot','cyclone']
client.send_message(ROBOT_NAMES[rand(ROBOT_NAMES.count)])
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