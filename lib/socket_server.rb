require_relative 'person'
require 'socket'
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

    def create_gameInterface_if_possible()
        
    end

    #PRIVATE HELPER METHODS
    def welcome_client_get_name(client)
        client.puts('Welcome! enter name: ')
        name = ''
        until name != '' 
            name = read_message(client) 
        end
        name
    end
    private :welcome_client_get_name
end