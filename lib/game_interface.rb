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
        until game.game_over? do
            people_with_cards = people.select {|person| person.player.cards_left > 0}
            people_with_cards.each do |person|
                take_turn(person) if person.robot == false
                robot_take_turn(person) if person.robot
            end
        end
    end

    def robot_take_turn(robot)
        before_turn(robot)
        get_robot_guess(robot) if robot.player.cards_left != 0 
        game.player_go_fish(robot.player) if robot.player.cards_left == 0
    end

    def get_robot_guess(robot)
        guess = robot.make_guess(get_player_names(robot))   
        player = name_to_person[guess[0]].player #package robot guess like this ['player_name, 'card_rank']
        card = guess[1]
        update_round_info(robot,player,card)
        get_cards(robot,card,player)
    end

    def before_turn(person)
        reset_turn_info
        attempt_to_lay_book(person)
    end

    def take_turn(person)
        server.send_message(person.client,"Your Hand: #{person.player.display_hand}")
        before_turn(person)
        ask_person_for_info(person) if person.player.hand != []
        game.player_go_fish(person.player) if person.player.hand == []
    end

    def ask_person_for_info(person)
        player_asked = ask_for_player(person) 
        card_asked_for = ask_for_card(person)
        update_round_info(person,player_asked,card_asked_for)
        get_cards(person,card_asked_for,player_asked)
    end

    def update_round_info(person,player_asked,card_asked_for)
        set_turn_info("#{person.name} asked #{player_asked.name} for a #{card_asked_for} ")
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
        game.player_go_fish(person.player) if cards_awarded == [] 
        provide_turn_information
        take_turn(person) if cards_awarded != [] && person.robot == false
        robot_take_turn(person) if cards_awarded != [] && person.robot
    end

    def provide_turn_information
        people.each  do |person| 
            server.send_message(person.client, turn_info) if person.robot == false
            person.collect_round_info(turn_info) if person.robot
        end
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
            server.send_message(person.client,"What card? options: #{person.player.display_hand}")
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