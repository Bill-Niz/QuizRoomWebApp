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
    @server = @server = TCPServer.open(@port)
    
    @ssl_context = OpenSSL::SSL::SSLContext.new()

    @ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("ssl/server.crt"))

    @ssl_context.key = OpenSSL::PKey::RSA.new(File.open("ssl/server.key"))

    @ssl_socket = OpenSSL::SSL::SSLServer.new(@server, @ssl_context)
 
    self.loadChannelList
    run()
    
  end
  
  
  def run
   
   loop {
     begin
      @threads.add(Thread.new(@ssl_socket.accept,@userList) { |socket, userList|
          puts "log: Connection from #{socket.peeraddr[2]} at
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
  ##
  #
  ##
  def loadChannelList
    @channelList.add(Channel.new)
  end
  
  ##
  #
  ##
  def sendToUser(fromIdUser,toIdUser)
    
  end
  
  ##
  #
  ##
  def sendToChannel(fromIdUser,toIdChannel)
  end
  ##
  #
  ##
  def onContentChanged(source,data)
    
    case source
    when @userList
      puts "user Added \n"
    when @channelList
      puts "Channel Added"
    when @threads
      puts "Tread Added"
    else
      puts "Unknow Source!"
    end
    
  end
  ##
  #
  ##
  def onContentAdded(source,data)
    puts source
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
  ##
  #
  ##
  def onContentRemoved(souce,data)
    puts source
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
