# To change this template, choose Tools | Templates
# and open the template in the editor.

class User
  def initialize(socket,chatServer)
    @id = ""
    @socket = socket
    @chatServer = chatServer
    @connected = true
    @thread = repeat_every(5) do
  @socket.puts(Time.now.ctime)
end  
    
    
  end
  
  def repeat_every(interval)
  Thread.new do
    loop do
      start_time = Time.now
      yield
      elapsed = Time.now - start_time
      sleep([interval - elapsed, 0].max)
    end
  end
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
