require_relative '../lib/socket_server'
require 'socket'
describe "SocketServer" do 

    let!(:clients) {[]}
    let!(:server) {SocketServer.new()}

    after(:each) do 
        clients.each {|client| client.close}
        server.stop
    end

    def make_and_accept_clients(number)
        number.times do 
            client = TCPSocket.new('localhost',server.port_number)
            clients.push(client)
            client.puts('Trevor')
            server.accept_client
        end
    end

    context '#accept_client' do 
        it 'accepts a client' do 
            client = TCPSocket.new('localhost',server.port_number)
            clients.push(client)
            client.puts('Trevor')
            server.accept_client
            expect(server.people[0].name).to eq "Trevor"
            expect(server.people.count).to eq 1
        end
    end

    context '#read_message' do 
        it 'read message from client' do 
            client = TCPSocket.new('localhost',server.port_number)
            clients.push(client)
            socket = server.server.accept_nonblock
            client.puts('whatever')
            expect(server.read_message(socket)).to eq 'whatever'
        end
    end

    context '#send_message' do 
        it 'send message to client' do 
            client = TCPSocket.new('localhost',server.port_number)
            clients.push(client)
            socket = server.server.accept_nonblock
            server.send_message(socket,'hello player')
            expect(client.gets.chomp).to eq 'hello player'
        end
    end

    context '#create_gameInterface_if_possible' do
        it 'creates a game interface if 3 clients connect' do
            make_and_accept_clients(3)
            game_interface = server.create_gameInterface_if_possible()
            expect(server.game_interfaces.count).to eq 1
        end
        it 'does not create a game if less than three players are connected' do 
            make_and_accept_clients(2)
            server.create_gameInterface_if_possible()
            expect(server.game_interfaces.count).to eq 0 
        end
        it 'clears array of people after a game interface is made' do 
            make_and_accept_clients(3)
            game_interface = server.create_gameInterface_if_possible()
            expect(server.people.count).to eq 0
        end
    end
end