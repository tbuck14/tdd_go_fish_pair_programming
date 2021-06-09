class Player
    attr_reader :hand
    def initialize(hand = [])
        @hand = hand
    end

    def add_cards_to_hand(cards)
        hand.concat(cards)
    end

    def cards_left()
        hand.count
    end 

end