require 'player'

describe 'Player' do 

    context '#add_cards_to_hand' do 
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
        it 'removes cards that match the given rank from the hand' do 
            cards = [Card.new('J'),Card.new('Q'),Card.new('Q')]
            player = Player.new(cards)
            player.give_cards('Q')
            expect(player.hand).to eq [cards[0]]
        end
        it 'returns cards that match the rank' do 
            cards = [Card.new('K'),Card.new('Q'),Card.new('K'),Card.new('K')]
            player = Player.new(cards)
            cards_given = player.give_cards('K')
            expect(cards_given).to eq cards.reject {|card| card.rank != 'K'}
        end
    end
    context '#cards_left' do 
        it 'returns the number of cards in a players hand' do 
            player = Player.new()
            expect(player.cards_left).to eq 0
            player.add_cards_to_hand([Card.new('J'),Card.new('Q')])
            expect(player.cards_left).to eq 2
        end
    end

    context '#try_to_lay_book' do 
        it 'looks for a book and removes it from hand' do 
            cards = [Card.new('K'),Card.new('K'),Card.new('K'),Card.new('K')]
            player = Player.new(cards)
            player.try_to_lay_book()
            expect(player.hand).to eq []
        end
        it 'increments score if a book is layed' do 
            cards = [Card.new('K'),Card.new('K'),Card.new('K'),Card.new('K')]
            player = Player.new(cards)
            player.try_to_lay_book()
            expect(player.score).to eq 1
        end
        it 'returns a rank if the player has layed a book' do 
            cards = [Card.new('K'),Card.new('K'),Card.new('K'),Card.new('K')]
            player = Player.new(cards)
            expect(player.try_to_lay_book()).to eq 'K'
        end
    end
end