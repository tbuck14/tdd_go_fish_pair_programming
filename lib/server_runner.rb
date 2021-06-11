require 'socket'
require_relative 'socket_server'
server = SocketServer.new()
def get_winner_names(winners)
    winner_names = []
    winners.each {|winner| winner_names.push(winner.name)}
    winner_names
end
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
                server.send_message(person.client,"The winner is: #{get_winner_names(gameInterface.game.winners)}")
            end
        end
    end
end