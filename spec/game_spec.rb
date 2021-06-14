require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/card'

describe 'Game' do 
    let(:player1) {Player.new('stephen',[])}
    let(:player2) {Player.new('ben',[])}
    let(:player3) {Player.new('dummie',[])}
    let(:game) {Game.new([player1,player2,player3])}
    context '#start' do 
        it 'deals each player 5 cards' do 
            game.start
            expect(player1.cards_left).to eq 5
            expect(player2.cards_left).to eq 5
            expect(player3.cards_left).to eq 5
        end
    end

    context '#game_over?' do 
        it 'returns false if not all books have been layed' do 
            game.start
            expect(game.game_over?).to eq false
        end
        it 'returns true if all books have been layed' do 
            game.start 
            13.times {player1.increase_score}
            expect(game.game_over?).to eq true
        end 
        it 'returns true if all books have been layed by multiple people' do 
            game.start
            
        end
    end

    context '#winner' do 
        it 'returns empty array if no winner' do 
            expect(game.winners.count).to eq 0
        end
        it 'returns a single winning player in an array' do
            player1.increase_score
            expect(game.winners[0].name).to eq 'stephen'
        end
        it 'returns an array of multiple players with the same ending score' do 
            player1.increase_score
            player2.increase_score
            expect(game.winners.include?(player1)).to eq true
            expect(game.winners.include?(player2)).to eq true
        end
    end

    context '#player_go_fish' do 
        it 'deals a player a card from the deck' do 
            game.player_go_fish(player1)
            expect(player1.cards_left).to eq 1
        end
        it 'returns the card that was dealt' do 
            ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
            expect(game.player_go_fish(player1)).to_not eq nil
            expect(ranks.include?(game.player_go_fish(player1)[0].rank)).to eq true
        end
    end

    context '#player_asks_for_card' do 
        it 'returns an empty array if the player doesnt get the card asked for' do 
            cards_returned = game.player_asks_for_card(player1,'A',player2)
            expect(cards_returned.count).to eq 0 
        end
        it 'returns an array of cards if the player does get the card asked for' do 
            player2.add_cards_to_hand([Card.new('A'),Card.new('A'),Card.new('A')])
            cards_returned = game.player_asks_for_card(player1,'A',player2)
            expect(cards_returned.count).to eq 3
        end
        it 'adds asked for cards (if any) to the players hand' do 
            player1.add_cards_to_hand([Card.new('A'),Card.new('A'),Card.new('A'),Card.new('K')])
            game.player_asks_for_card(player2, 'A',player1)
            expect(player2.cards_left).to eq 3
        end
    end
    context  '#got_card_asked_for' do
        it 'returns true if the card matches the card asked for' do
            player2.add_cards_to_hand([Card.new('3')])
            game.player_asks_for_card(player1,'3',player2)
            expect(game.got_card_asked_for('3')).to eq true
        end 
        it 'returns false if the card does not match the card asked for' do
            player2.add_cards_to_hand([Card.new('2')])
            game.player_asks_for_card(player1,'3',player2)
            expect(game.got_card_asked_for('2')).to eq false
        end
    end

end