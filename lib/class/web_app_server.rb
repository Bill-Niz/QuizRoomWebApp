# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'



class WebAppServer < Sinatra::Base
  
  def initialize(port = 8443,cert_path = 'ssl/')
    super(self)
    @port = port
    @CERT_PATH = cert_path
    @webrick_options = {
        :Port               => @port,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => "/Users/kmeleon/Sites",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(File.open(File.join(@CERT_PATH,"server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(File.open(File.join(@CERT_PATH,"server.key")).read),
        :SSLCertName        => [[ "CN",WEBrick::Utils::getservername ]]
    }
    Rack::Handler::WEBrick.run self, @webrick_options
  end
  
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
