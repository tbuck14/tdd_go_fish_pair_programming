class GameInterface
    attr_reader :people, :game, :server, :name_to_person
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
        player_asked = ask_for_player(person)
        card_asked_for = ask_for_card(person)
    end

    def ask_for_player(person)
        server.send_message(person.client,"what player would you like to ask? options: #{get_player_names(person)}")
    end

    def ask_for_card(person)

    end

    def hash_names_to_people()
        name_hash = {}
        people.each {|person| name_hash[person.name] = person}
        name_hash
    end
end