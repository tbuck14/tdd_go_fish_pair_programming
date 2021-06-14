require_relative 'person'
require_relative 'robot_person'
require_relative 'game_interface'
require 'socket'
# ip address: '10.0.0.185'
class SocketServer
    attr_reader :server, :people, :game_interfaces
    def initialize()
        @server = TCPServer.new('localhost',port_number)
        puts "Server Started"
        @people = []
        @game_interfaces = []
    end

    def stop()
        server.close if server
    end

    def port_number()
        3336
    end

    def accept_client()
        client = server.accept_nonblock
        start_server_timeout_count
        name = welcome_client_get_name(client)
        person = Person.new(client,name)
        people.push(person)
    rescue IO::WaitReadable
        'no client'
    end

    def send_message(client, message)
        client.puts(message)
    end
    
    def read_message(client)
        sleep(0.1)
        client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
        ''
    end

    def start_server_timeout_count()
        Thread.new do
            sleep(20)
            populate_people()
        end
    end

    def populate_people()
        until people.count == 3
            people.push(RobotPerson.new(people.count - 1))
        end
    end

    def create_gameInterface_if_possible()
        if people.count == 3
            gameInterface = GameInterface.new(people,self)
            game_interfaces.push(gameInterface)
            reset_people
        end
        gameInterface
    end

    def reset_people()
        @people = []
    end
    private
    
    def welcome_client_get_name(client)
        send_message(client,'Welcome to Go Fish! enter your name: ')
        name = ''
        until name != '' 
            name = read_message(client) 
        end
        name
    end
    
end