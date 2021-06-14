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
                server.send_message(person.client,"Game Starting") if person.robot == false#if person is not a robot
            end
            gameInterface.game.start
            gameInterface.play_full_game
            puts "The winner is: #{get_winner_names(gameInterface.game.winners)}"
            gameInterface.people.each do |person|
                server.send_message(person.client,"The winner is: #{get_winner_names(gameInterface.game.winners)}") if person.robot == false #if person is not a robot
            end
        end
    end
end