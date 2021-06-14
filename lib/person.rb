require_relative 'player'

class Person
    attr_reader :player, :client, :name, :robot
    def initialize(client,name)
        @player = Player.new(name,[])
        @client = client
        @name = name
        @robot = false
    end
end