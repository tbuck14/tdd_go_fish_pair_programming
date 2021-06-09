require_relative '../lib/socket_server'
require 'socket'
describe "SocketServer" do 

    let!(:clients) {[]}
    let!(:server) {SocketServer.new()}

    after(:each) do 
        clients.each {|client| client.close}
        server.stop
    end

    context '#accept_client' do 
        it 'accepts a client' do 
            client = TCPSocket.new('localhost',server.port_number)
            socket = server.accept_client
            expect(server.clients.count).to eq 1
        end
    end

    context '#read_message' do 
        it 'read message from client' do 
            client = TCPSocket.new('localhost',server.port_number)
            socket = server.server.accept_nonblock
            client.puts('whatever')
            expect(server.read_message(socket)).to eq 'whatever'
        end
    end

    context '#send_message' do 
        it 'send message to client' do 
            client = TCPSocket.new('localhost',server.port_number)
            socket = server.server.accept_nonblock
            server.send_message(socket,'hello player')
            expect(client.gets.chomp).to eq 'hello player'
        end
    end

end