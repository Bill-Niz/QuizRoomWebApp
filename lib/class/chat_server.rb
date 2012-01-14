# To change this template, choose Tools | Templates
# and open the template in the editor.
load "module/content_changed.rb"
load "thread_repository.rb"
load "channel.rb"
require 'openssl'
require "socket"

class ChatServer
  include ContentChanged
  
  def initialize(port)
    @port = port
    @userList = UserRepository.new
    @userList.addContentChangedListener(self)
    
    @channelList = ChannelRepository.new
    @channelList.addContentChangedListener(self)
    
    @threads = ThreadRepository.new
    @threads.addContentChangedListener(self)
    @mysqlHelper = MysqlHelper.new
    @server = @server = TCPServer.open(@port)
    
    @ssl_context = OpenSSL::SSL::SSLContext.new()

    @ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("ssl/server.crt"))

    @ssl_context.key = OpenSSL::PKey::RSA.new(File.open("ssl/server.key"))

    @ssl_socket = OpenSSL::SSL::SSLServer.new(@server, @ssl_context)
 
    self.loadChannelList
    run()
    
  end
  
  #
  #
  #
  def run
   
   loop {
     begin
       puts "Chat Server Started at #{Time.now} on Port : #{@port}"
      @threads.add(Thread.new(@ssl_socket.accept,@userList) { |socket, userList|
          puts "Log: Connection from #{socket.peeraddr[2]} at
          #{socket.peeraddr[3]}"
          user = User.new(socket,self)
          userList.add(user)
          user.run
      
    })
    rescue OpenSSL::SSL::SSLError => e
      puts " #{e.to_s} "
      retry
    rescue
      puts "Unknown Error"
      retry
     end
}
  end
  #
  #
  #
  def loadChannelList
    @mysqlHelper.getChannelList.each { |chan| 
      @channelList.add(Channel.new(chan["name"],chan["id"]))
    }
  end
  #
  #
  #
  def sendToUser(fromIdUser,toIdUser,msg)
    @userList.getcontents.each { |user| 
      if user.getId == toIdUser
        user.receiveFromUser(fromIdUser, msg)
        break
      end
      
    }
  end
  #
  # User Join a channel
  #
  def joinChannel(user,idChannel)
    
    getChannelById(idChannel).join(user)
  end
  #
  # User Join a channel
  #
  def quitChannel(user,idChannel)
    
    getChannelById(idChannel).remove(user)
  end
  #
  # Send data the channel from an user
  #
  def sendToChannel(fromIdUser,toIdChannel,msg)
    getChannelById(toIdChannel).send(fromIdUser, msg)
  end
  #
  # Disconnect user from the server:
  # Remove from all channel
  # Remove from User list
  #
  #
  def disconnectUser(user)
    @userList.remove(user)
     @channelList.getcontents.each { |chan| 
    
      if(chan.isIn(user))
        chan.remove(user)
      end
    } 
  end
  #
  #
  #
  def getChannelById(id)
    @channelList.getcontents.each { |chan| 
    
      if(chan.getId == idChannel)
        return chan
        
      end
    }
  end
  #
  #
  #
  def onContentChanged(source,data)
    
    case source
    when @userList
      puts "user Added \n"
    when @channelList
      puts "Channel Added : #{data.to_s}"
    when @threads
      puts "Tread Added"
    else
      puts "Unknow Source!"
    end
    
  end
  #
  #
  #
  def onContentAdded(source,data)
    
    case source
    when @userList
      puts "#{data.to_s} : Join the Server !"
    when @channelList
    when @threads
      puts "New client Connected ! : #{data.to_s}"
    else
      puts "Unknow Source!"
    end
    
  end
  #
  #
  #
  def onContentRemoved(source,data)
    
    case source
    when @userList
      puts "#{data.to_s} : Quit the Server !"
    when @channelList
    when @threads
      puts "New client Disconnected ! : #{data.to_s}"
    else
      puts "Unknow Source!"
    end
    
  end
  
end
