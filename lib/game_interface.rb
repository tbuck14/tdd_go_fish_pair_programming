require_relative 'game'
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
            people.each do |person|
                
                take_turn(person)
            end
        end
    end

    def take_turn(person)
        reset_turn_info
        server.send_message(person.client, "HAND: #{person.player.display_hand}")
        attempt_to_lay_book(person)
        ask_person_for_info(person) if person.player.hand != []
        player_go_fish(person.player) if person.player.hand == []
    end

    def ask_person_for_info(person)
        player_asked = ask_for_player(person) 
        card_asked_for = ask_for_card(person)
        set_turn_info("#{person.name} asked #{player_asked.name} for a #{card_asked_for} ")
        get_cards(person,card_asked_for,player_asked)
    end

    def attempt_to_lay_book(person)
        book = person.player.try_to_lay_book
        if book != nil
            set_turn_info("#{person.name} has layed a book of #{book}s\n")
        end
    end

    def get_cards(person,card_asked, asked_player)
        cards_awarded = game.player_asks_for_card(person.player,card_asked,asked_player)
        set_turn_info("and got #{cards_awarded.count}") if cards_awarded != []
        player_go_fish(person.player) if cards_awarded == [] 
        provide_turn_information
        take_turn(person) if cards_awarded != []
    end

    def provide_turn_information
        people.each {|person| server.send_message(person.client, turn_info)}
    end

    def ask_for_player(person)
        name = ""
        until get_player_names(person).include?(name) do 
            server.send_message(person.client,"What player would you like to ask? options: #{get_player_names(person)}")
            name = wait_for_response(person)
            server.send_message(person.client,"not a valid player name!") if get_player_names(person).include?(name) == false
        end
        name_to_person[name].player
    end

    def ask_for_card(person)
        card = ""
        until RANKS.include?(card) && person.player.hand_ranks.include?(card) do
            server.send_message(person.client,"What card do you want to ask for? example: Q")
            card = wait_for_response(person)
            server.send_message(person.client,"not a card you can ask for!") if RANKS.include?(card) == false || person.player.hand_ranks.include?(card) == false
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

    def reset_turn_info()
        @turn_info = ""
    end

    def wait_for_response(person)
        response = ""
        until response != "" do 
            response = server.read_message(person.client)
        end
        response
    end
end