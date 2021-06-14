class RobotPerson
    attr_reader :name, :player, :robot, :player_with_card
    NAMES = ['zap','bolts','robo','shocker','buzz','boba','spaz','wal-e']
    def initialize(name_index)
        @player = Player.new(NAMES[name_index],[])
        @name = NAMES[name_index]
        @robot = true
        @player_with_card = {'2'=>nil,'3'=>nil,'4'=>nil,'5'=>nil,'6'=>nil,'7'=>nil,'8'=>nil,'9'=>nil,'10'=>nil,'J'=>nil,'Q'=>nil,'K'=>nil,'A'=>nil}
    end

    def make_guess(players)
        player.hand.each do |card|
            if player_with_card[card.rank] != nil
                return [player_with_card[card.rank],card.rank]
            end
        end
        make_random_guess(players)
    end

    def make_random_guess(players)
        return_info = []
        name = players.sample
        card = player.hand.sample.rank
        return_info.push(name)
        return_info.push(card)
        return_info
    end
    #example string: ddr4 asked r2d2 for a 6 and got 1
    def collect_round_info(round_info)
        info = round_info
        info = info.split("\n").last if round_info.include?("\n")
        player_name = info.split(' asked')[0] 
        card_they_have = info.split(' asked')[1].split('for a ')[1][0]
        @player_with_card[card_they_have] = player_name if player_name != name
        @player_with_card[card_they_have] = nil if player_name == name
    end

end
