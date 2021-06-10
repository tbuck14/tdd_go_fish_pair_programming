class Game
    attr_reader :players, :deck
    def initialize(players)
        @players = players
        @deck = Deck.new()
    end

    def start()
        players.each do |player|
            5.times do 
                player.add_cards_to_hand([deck.deal])
            end
        end
    end

    def player_asks_for_card(player,card_rank,player_asked)
        player_asked.give_cards(card_rank)
    end

    def player_go_fish(player)
        card = deck.deal
        player.add_cards_to_hand([card])
        card
    end

    def winners()
        winners = []
        sort_players = players.sort_by {|player| player.score}
        if sort_players[-1].score > 0
            winners.push(sort_players[-1])
            sort_players.each {|player| winners.push player if player.score == sort_players.last.score}
        end
        winners
    end

    def game_over?()
        total_score = 0 
        players.each do |player|
            total_score += player.score
        end
        total_score == 13
    end
end