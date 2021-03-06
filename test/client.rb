# To change this template, choose Tools | Templates
# and open the template in the editor.
# To change this template, choose Tools | Templates
# and open the template in the editor.

#!/usr/bin/ruby



require 'socket'
require 'openssl'

ssl_socket.puts("GET / HTTP/1.0")
ssl_socket.puts("")

while line = ssl_socket.gets

  puts line

end

class Client
  def initialize host, port
    @host = host
    @port = port
    @socket = TCPSocket.new(@host, @port)

    @ssl_context = OpenSSL::SSL::SSLContext.new()

    @ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("../ssl/server.crt"))

    @ssl_context.key = OpenSSL::PKey::RSA.new(File.open("../ssl/server.key"))

    @ssl_socket = OpenSSL::SSL::SSLSocket.new(@socket, @ssl_context)

    @ssl_socket.sync_close = true

    @ssl_socket.connect
    
  end
  
  #Send request to the server
  def sendRequest(request)
    @ssl_socket.puts(request)
    response = ssl_socket.gets
    response
  end
  
  
  
end
