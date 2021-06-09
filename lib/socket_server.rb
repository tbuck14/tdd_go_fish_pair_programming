class SocketServer
    attr_reader :server, :clients
    def initialize()
        @server = TCPServer.new('localhost',port_number)
        @clients = []
    end

    def stop()
        server.close if server
    end

    def port_number()
        3336
    end

    def accept_client()
        client = server.accept_nonblock
        clients.push(client)
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

    def welcome_client_get_name(client)
        client.puts('Welcome! enter name: ')
        name = ''
        until name != '' 
            name = server.read_message(client) 
        end
        name
    end

    #PRIVATE HELPER METHODS

end