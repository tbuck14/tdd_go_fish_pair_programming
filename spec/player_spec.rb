require 'player'

describe 'Player' do 

    context '#take_cards' do 
        it 'pushes an array of cards onto the players hand' do
            player = Player.new()
            card = Card.new('J')
            player.add_cards_to_hand([card])
            expect(player.cards_left).to eq 1
            expect(player.hand).to eq [card]
        end
        it 'can take more than one card at once' do 
            player = Player.new()
            cards = [Card.new('J'),Card.new('Q')]
            player.add_cards_to_hand(cards)
            expect(player.cards_left).to eq 2
            expect(player.hand).to eq cards
        end
    end
    context '#give_cards' do 
        
    end
    context '#cards_left' do 
        it 'returns the number of cards in a players hand' do 
            player = Player.new()
            expect(player.cards_left).to eq 0
            player.add_cards_to_hand([Card.new('J'),Card.new('Q')])
            expect(player.cards_left).to eq 2
        end
    end
end