require 'socket'
require_relative 'socket_server'
server = SocketServer.new()
loop do
    server.accept_client
    gameInterface = server.create_gameInterface_if_possible()
    if gameInterface
        Thread.new(gameInterface) do |gameInterface|  
            gameInterface.people.each do |person|
                server.send_message(person.client,"Game Starting")
            end
            gameInterface.play_full_game
            gameInterface.people.each do |person|
                server.send_message(person.client,"The winner is: #{gameInterface.game.winners}")
            end
        end
    end
end