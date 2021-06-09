class Player
    attr_reader :hand
    def initialize(hand = [])
        @hand = hand
    end

    def add_cards_to_hand(cards)
        hand.concat(cards)
    end

    def give_cards(rank)
        cards_to_return = hand.reject {|card| card.rank != rank}
        set_hand(hand - cards_to_return)
        cards_to_return
    end

    def cards_left()
        hand.count
    end 

    def set_hand(new_hand)
        @hand = new_hand
    end

    private :set_hand
end