class SocketClient 
    attr_reader :socket
    def initialize(port)
        @socket = TCPSocket.new('localhost',port)
    end

    def send_message(message)
        socket.puts(message)
    end

    def read_message()
        sleep(0.1)
        socket.read_nonblock(1000).chomp
    rescue IO::WaitReadable 
        ''
    end

    def close()
        socket.close
    end

end