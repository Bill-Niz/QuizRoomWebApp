# To change this template, choose Tools | Templates
# and open the template in the editor.


require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require "test/unit"



module DataChangeListener
  
  def onDataChanged(source,data)
  end
end

module DataRemovedListner
  
  def onDataRemoved(source,data)
  end
end


class DataSource
  def initialize()
    @listListener = []
    @data = []
  end
  ###
  #
  ##
  def addDataChangedListener(listener)
    @listListener.push(listener)
  end
  ###
  #
  ##
  def fireDataChanged(data)
    
    @listListener.each { |listener|  
      if DataChangeListener.class === listener.class
        listener.onDataChanged(self,data)
      end
      }
  end
  ##
  #
  ##
  def addData (data)
    @data.push(data)
    self.fireDataChanged(@data)
  end
  
end

class ChangeEvent
  
end



class Test
  include DataChangeListener
  
  def initialize(s)
    @dataS = s
    @dataS.addDataChangedListener(self)
  end
  
   def onDataChanged(source,data)
     puts "Datachaged! > " + data.to_s 
   end
  
end

 CERT_PATH = '/Users/kmeleon/NetBeansProjects/QuizRoomWebApp/lib/ssl/'

webrick_options = {
        :Port               => 8443,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => "/Users/kmeleon/Sites",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(File.open(File.join(CERT_PATH,"server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(File.open(File.join(CERT_PATH,"server.key")).read),
        :SSLCertName        => [[ "CN",WEBrick::Utils::getservername ]]
}

class MyServer  < Sinatra::Base
    post '/' do
      "Hellow, worldjjj!"
    end
    get '/' do
      "Hellow, world!"
    end
    get '/favicon.ico' do
      send_file "favicon.ico"
    end
    
end

#Rack::Handler::WEBrick.run MyServer, webrick_options