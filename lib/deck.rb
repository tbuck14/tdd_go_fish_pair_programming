require_relative 'card'
class Deck  
    attr_accessor :cards
    RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    def initialize()
        @cards  = []
        build_deck
        cards.shuffle!
    end

    def deal()
        cards.pop()
    end

    def cards_left()
        cards.count
    end

    def build_deck()
        4.times do 
            RANKS.each {|rank| cards.push(Card.new(rank))}
        end
    end

end