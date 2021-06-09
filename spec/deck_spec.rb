require_relative '../lib/deck'

describe 'Deck' do 
    context '#deal' do 
        it 'deals a card from the deck' do
            deck = Deck.new()
            deck.deal
            expect(deck.cards_left).to eq 51
        end
        it 'deals two cards when called twice' do 
            deck = Deck.new
            deck.deal
            deck.deal
            expect(deck.cards_left).to eq 50
        end
    end
end