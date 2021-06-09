class Card
    attr_reader :rank
    CARD_RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    def initialize(rank)
        @rank = rank
    end

    def value()
        CARD_RANKS.index(rank) + 1
    end
end