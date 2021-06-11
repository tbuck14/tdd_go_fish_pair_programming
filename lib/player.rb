class Player
    attr_reader :hand, :score, :name
    RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    def initialize(name = 'randomPlayer',hand = [])
        @hand = hand
        @score = 0 
        @name = name
    end

    def add_cards_to_hand(cards)
        hand.concat(cards)
        if cards_left > 1 
            set_hand(hand.sort_by {|card| card.value}) 
        end
    end

    def give_cards(rank)
        cards_to_return = []
        cards_to_return = hand.reject {|card| card.rank != rank} if cards_left != 0 
        set_hand(hand - cards_to_return)
        cards_to_return
    end

    def try_to_lay_book()
        book = nil
        RANKS.each do |rank|
            book = search_for_rank(rank)
            break if book != nil
        end 
        book
    end

    def cards_left()
        hand.count
    end 

    def display_hand()
        displayed_hand = []
        hand.each do |card|
            displayed_hand.push("#{card.rank}")
        end
        displayed_hand
    end

    def hand_ranks()
        hand.map{|card| card.rank}
    end
    def increase_score()
        @score += 1
    end

    private 

    def set_hand(new_hand)
        @hand = new_hand
    end

    def lay_book(book)
        set_hand(hand - book)
    end

    def search_for_rank(rank)
        matching_cards = hand.reject {|card| card.rank != rank}
        if matching_cards.count == 4
            lay_book(matching_cards)
            increase_score
            return matching_cards.first.rank
        end
    end

end