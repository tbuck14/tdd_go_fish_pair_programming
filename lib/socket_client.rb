class SocketClient 
    attr_reader :socket
    def initialize(port)
        @socket = TCPSocket.new('localhost',port)
    end

    def send_message()
        
    end

    def read_message()

    end

    def close()
        socket.close
    end

end