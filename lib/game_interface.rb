class GameInterface
    attr_reader :people, :game, :server, :name_to_person, :turn_info
    RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    def initialize(people, server)
        @people = people
        @server = server
        @name_to_person = hash_names_to_people
        @game = Game.new(get_players)
        @turn_info = ""
    end

    def get_players
        players = people.map{|person| person.player}
    end

    def get_player_names(excluded_person)
        names = people.map{|person| person.name} - [excluded_person.name]
    end

    def play_full_game
        game.start
        until game.game_over? do
            game.people.each do |person|
                server.send_message(person.client, "HAND: #{person.player.display_hand}")
                take_turn(person)
            end
        end
    end

    def take_turn(person)
        book = person.player.try_to_lay_book
        if book != nil
            set_turn_info("#{person.name} has layed a book of #{book}s\n")
        end
        player_asked = ask_for_player(person)
        card_asked_for = ask_for_card(person)
        get_cards(person,player_asked,card_asked_for)
    end

    def get_cards(person, asked_player, card_asked)
        cards_awarded = game.player_asks_for_card(person.player,card_asked_for,player_asked)
        set_turn_info("and got #{cards_awarded.count}") if cards_awarded != []
        cards_awarded = game.player_go_fish(person.player) if cards_awarded == [] 
        provide_turn_information
        take_turn(person) if game.got_card_asked_for(cards_awarded[0].rank)
    end

    def provide_turn_information
        people.each {|person| server.send_message(person.client, turn_info)}
    end

    def ask_for_player(person)
        loop do 
            server.send_message(person.client,"what player would you like to ask? options: #{get_player_names(person)}")
            name = wait_for_response(person)
            break if get_player_names(person).include?(name)
            server.send_message(person.client,"not a valid player name!")
        end
        name_to_person[name].player
    end

    def ask_for_card(person)
        loop do
            server.send_message(person.client,"what card do you want to ask for? example: Q")
            card = wait_for_response(person).upcase
            break if RANKS.include?(card) && (person.player.display_hand).include?(card) == false
            server.send_message(person.client,"not a card you can ask for!")
        end
        card
    end

    def hash_names_to_people()
        name_hash = {}
        people.each {|person| name_hash[person.name] = person}
        name_hash
    end

    def set_turn_info(string_to_add)
        @turn_info = @turn_info + string_to_add
    end

    def wait_for_response(person)
        response = ""
        until response != "" do 
            server.read_message(person.client)
        end
        response
    end
end