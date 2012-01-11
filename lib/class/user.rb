# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')


##
#
# Data format
# 
# Reception
# 100/  : Code for User manager
# 200/  : Code for Chat manager
# 300  : Code for Quiz manage
# 
# Reponse
# 400/ : OK
# 500/ : NOK
#
#
#
##

class User
  
  NOK_UNKNOWN_COMMAND = "520/Unknown command"
  OK_LOGGEG = "410/Authentication successful"
  NOK_BAD_LOGGING = "510/Bad UUID"
  OK = "400/ok"
  NOK = "500/NOK"
  
  def initialize(socket,chatServer)
    @uuid = ""
    @id = ""
    @socket = socket
    @chatServer = chatServer
    @mysqlHelper = MysqlHelper.new
    @connected = true
    @logged = false         # => know if user is authentified
    @isActive = true       # => user connected but the app is in background
    
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
  
  #
  # Loop listening for incomming data
  #
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
  #
  # Parsing the incomming data
  #
  def processIncomingData(data)
    begin
      dataArray = data.split('/')
      case dataArray[0][0]
        
        
        
        
      when '1'                # => User Manager
        
        case dataArray[0]
        when '101'          # => 101 => Set id
          self.setId=(dataArray[1])
          
        when '102'
          @chatServer.joinChannel(@uuid,dataArray[1])
          
        when '110'          # => 110 => Set user inactive
          @isActive = false
          
        when '111'          # => 111 => Set user active
          @isActive = true
          
        else
          self.send(NOK_UNKNOWN_COMMAND)
        end
        
        
        
        
        
      when '2'                # => Chat Manager
        
         case dataArray[0]
        # Send message to user
        when '200'
          @chatServer.sendToUser(@uuid, dataArray[1], dataArray[2])
          
          # Send message to channel
        when '201'
          @chatServer.sendToChannel(@uuid, dataArray[1], dataArray[2])
          
          # Join a channel
        when '202'
          @chatServer.joinChannel(self, dataArray[1])
          
          # Quit a channel
        when '203'
          @chatServer.quitChannel(self, dataArray[1])
          
         else
           self.send(NOK_UNKNOWN_COMMAND)
        end
        
        
        
        
        
        
        
      when '3'                # => Quiz Manager
        
         case dataArray[0]
        when ''
         else
           self.send(NOK_UNKNOWN_COMMAND)
        end
        
      else
        self.send(NOK_UNKNOWN_COMMAND)
      end
      
      
     
    end
  end
  
  #
  # Check if the client is still connected
  #
  def connected?
    @connected && !(@socket.closed?) 
  end
  #
  #Check if the client isLogged
  #
  #
  def isLogged?
    @logged
  end
  ##
  #
  # Check if the client is active
  ##
  def isActive?
    @isActive
  end
  #
  # Check if when can send data to client
  #
  def isSendAble?
    self.connected? && self.isActive?
  end
  
  #
  # Send data to the client
  #
  def send(data)
    if self.isSendAble?
      @socket.puts(data)
    end
  end
  
  #
  # receive message from other user
  #
  def receiveFromUser(fromId,msg)
    d = "210/#{fromId}/#{msg}"
    self.send(d)
  end
  #
  # receive message from other user in the channel
  #
  def receiveFromChannel(fromIdChan,fromIdUser,msg)
    dataMsg = "220/#{fromIdChan}/#{fromIdUser}/#{msg}"
    self.send(dataMsg)
  end
  #
  # Receive message from the channel
  # if an user join or quit the channel
  # code : 204 => Joinning channel
  # code : 205 => Quitting channel
  #
  def userChangeFromChannel(code,fromidchan,fromid)
    dataMsg = "#{code}/#{fromidchan}/#{fromid}"
    self.send(dataMsg)
    
  end
  #
  # Get the user uuid
  #
  def getId
    return @uuid
  end
  #
  # Get the user uuid
  #
  def getI
    return @id
  end
  #
  #
  #
  def setId=(value)
    id = @mysqlHelper.isInDB(MysqlHelper::CLIENT_DB_USER, "uuid", value)
    unless id
      then
      self.send(NOK_BAD_LOGGING)
    else
      @uuid = value
      @id = id
      @logged =true
      self.send(OK_LOGGEG)
    end
    
  end
  
  private :processIncomingData
  
  
end
