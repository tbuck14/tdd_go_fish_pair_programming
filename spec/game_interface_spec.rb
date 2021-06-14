require_relative '../lib/game_interface'
require_relative '../lib/player'
class MockPerson
    attr_reader :player, :name
    def initialize(player, name = "notta")
        @player = player
        @name = name
    end
end

describe 'GameInterface' do
    context '#get_players' do
        it 'gets an array of players from an array of people' do
            people = [MockPerson.new(Player.new()),MockPerson.new(Player.new()),MockPerson.new(Player.new())]
            players = [people[0].player,people[1].player,people[2].player]
            game_interface = GameInterface.new(people, 'server')
            expect(game_interface.get_players).to match_array(players)
        end
    end
    context '#get_player_names_excluding' do 
        it 'returns a list of player names excluding the player whose turn it is' do
            person = MockPerson.new(Player.new(),'trevor')
            people = [MockPerson.new(person,'trevor'),MockPerson.new(Player.new(),'stephen'),MockPerson.new(Player.new(),'roy')]
            game_interface = GameInterface.new(people, 'server')
            expect(game_interface.get_player_names_excluding(person)).to match_array(['stephen','roy'])

        end
    end
end