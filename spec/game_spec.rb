require_relative '../lib/game'


describe 'Game' do 

    let!(:game) {Game.new([Player.new('stephen',[]),Player.new('ben'),Player.new('dummie')])}
    context '#start' do 
        it 'deals each player 5 cards' do 
            game.start
            expect(game.players[0].hand.count).to eq 5
            expect(game.players[1].hand.count).to eq 5
            expect(game.players[2].hand.count).to eq 5
        end
    end

    context '#game_over?' do 
        it 'returns true if all all books have been layed' do 
            game.start
            expect(game.game_over?).to eq false
        end
        it 'returns false if not all books have been layed' do 
            game.start 
            13.times {game.players[0].increase_score}
            expect(game.game_over?).to eq true
        end 
    end

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

    context '#player_go_fish' do 
        it 'deals a player a card from the deck' do 
            game.player_go_fish(game.players[0])
            expect(game.players[0].hand.count).to eq 1
        end
        it 'returns the card that was dealt' do 
            expect(game.player_go_fish(game.players[0])).to_not eq nil
        end
    end

    context '#player_asks_for_card' do 
        it 'returns an empty array if the player doesnt get the card asked for' do 
            cards_returned = game.player_asks_for_card(game.players[0],'A',game.players[1])
            expect(cards_returned.count).to eq 0 
        end
        it 'returns an array of cards if the player does get the card asked for' do 
            game.players[1].add_cards_to_hand([Card.new('A'),Card.new('A'),Card.new('A')])
            cards_returned = game.player_asks_for_card(game.players[0],'A',game.players[1])
            expect(cards_returned.count).to eq 3
        end
    end

end