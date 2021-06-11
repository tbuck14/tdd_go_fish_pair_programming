require_relative 'player'

class Person
    attr_reader :player, :client, :name
    def initialize(client,name)
        @player = Player.new(name,[])
        @client = client
        @name = name
    end
end