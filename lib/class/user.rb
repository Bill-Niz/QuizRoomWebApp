# To change this template, choose Tools | Templates
# and open the template in the editor.

class User
  def initialize(socket,chatServer)
    @id = ""
    @socket = socket
    @chatServer = chatServer
    @connected = true
    @socket.puts(Time.now.ctime)
    
  end
  
  ##
  #
  ##
  def run 
    while self.connected?
      line = @socket.gets unless @socket.closed?
      if(line == nil)
        @socket.close
      end
      self.processIncomingData(line)
     
    end
    puts "Connection Closed!"
  end
  ##
  #
  ##
  def processIncomingData(data)
    puts data
  end
  
  ##
  #
  ##
  def connected?
    @connected && !(@socket.closed?) 
  end
  
  
  ##
  #
  ##
  def setId=(value)
    @id = value
  end
  
  private :processIncomingData
  
  
end
