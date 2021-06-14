class RobotPerson
    attr_reader :name, :player, :robot
    NAMES = ['zap','bolts','robo','shocker','buzz','boba','spaz','wal-e']
    def initialize(name_index)
        @player = Player.new(NAMES[name_index],[])
        @name = NAMES[name_index]
        @robot = true
    end

    def send_message(message)
        
    end

    def read_message()
     
    end

    def make_guess()

    end

end