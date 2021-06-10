require_relative '../lib/game'


describe 'Game'do 
    let!(:game) {Game.new([Player.new('stephen',[]),Player.new('ben'),Player.new('dummie')])}
    context '#start' do 
        it 'deals each player 5 cards' do 
            game.start
            expect(game.players[0].hand.count).to eq 5
            expect(game.players[1].hand.count).to eq 5
            expect(game.players[2].hand.count).to eq 5
        end
    end

    context ''
    context '#winner' do 
        it 'returns empty array if no winner' do 
            expect(game.winners.count).to eq 0
        end
        it 'returns a single winning player in an array' do
            game.players[0].increase_score
            expect(game.winners[0].name).to eq 'stephen'
        end
        it 'returns an array of multiple players with the same ending score' do 
            game.players[0].increase_score
            game.players[1].increase_score
            expect(game.winners.include?(game.players[0])).to eq true
            expect(game.winners.include?(game.players[1])).to eq true
        end
    end
end