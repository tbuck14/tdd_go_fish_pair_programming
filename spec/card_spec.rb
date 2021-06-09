require_relative '../lib/card'

describe "Card" do 
    context '#value' do 
        it 'returns a value 13 for an ace' do 
            card = Card.new('A')
            expect(card.value).to eq 13
        end
        it 'returns a 10 for a J' do 
            card = Card.new('J')
            expect(card.value).to eq 10
        end
    end
end