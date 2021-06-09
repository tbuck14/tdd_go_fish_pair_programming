require_relative '../lib/socket_client'
require 'socket'
describe "SocketClient" do 
    before(:each) do 
        @server = TCPServer.new('localhost',3335)
        @clients = []
    end
    after(:each) do 
        @clients.each do |client|
            client.close
        end
        @server.close
    end
    def make_client()
        client = SocketClient.new(3335)
        @clients.push(client)
        client 
    end
    context '#send_message' do 
        it 'sends message to the server' do 
            client = make_client
            socket = @server.accept_nonblock
            client.send_message('hello')
            sleep(0.1)
            expect(socket.read_nonblock(1000).chomp).to eq 'hello'
        end
    end
    context '#read_message' do 
        it 'gets message from the server' do 
            client = make_client
            socket = @server.accept_nonblock 
            socket.puts('hello fred')
            expect(client.read_message).to eq('hello fred')
        end
    end
    
end