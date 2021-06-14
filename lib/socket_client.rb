require 'socket'


class SocketClient 
    attr_reader :socket
    def initialize(port)
        @socket = TCPSocket.new('10.0.0.185',port)
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