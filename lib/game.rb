require_relative 'deck'
class Game
    attr_reader :players, :deck, :card_asked_for
    def initialize(players)
        @players = players
        @deck = Deck.new()
        @card_asked_for = nil
    end

    def start()
        players.each do |player|
            5.times do 
                player.add_cards_to_hand([deck.deal])
            end
        end
    end

    def player_asks_for_card(player,card_rank,player_asked)
        set_card_asked_for(card_rank)
        cards = player_asked.give_cards(card_rank)
        player.add_cards_to_hand(cards)
        cards
    end

    def player_go_fish(player)
        card = [deck.deal]
        card = [] if card == [nil]
        player.add_cards_to_hand(card)
        card
    end

    def got_card_asked_for(card_rank)
        card_asked_for == card_rank
    end

    def set_card_asked_for(card_rank)
        @card_asked_for = card_rank
    end

    def winners()
        winners = []
        sort_players = players.sort_by {|player| player.score}
        if sort_players.last.score != 0 
            winners.push(sort_players.pop())
            sort_players.each {|player| winners.push(player) if player.score == winners[0].score}
        end
        winners
    end

    def game_over?()
        players.reduce(0) {|total,player| total + player.score} == 13
    end
end