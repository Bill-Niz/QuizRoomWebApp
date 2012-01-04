# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
load 'web_app_submit.rb'



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
  
   use WebAppSubmit
   
  
  
  
   post '/submit/:method' do
      request.body.rewind
      data = JSON.parse request.body.read
      
      case params[:method]
      when 'facebook'
        #TODO Check DATA validity!
        s = Submit.new(data, 'facebook')
        s.proceedSubmit
       
      when 'normal'
        #TODO Check DATA validity!
         s = Submit.new(data, 'normal')
         s.proceedSubmit
        
      else
        '{"error":"Unknow method",
          "messafe":"Unknow method; Should be "facebook" or "normal""}'
        
      end
     
      
   end
    
    get '/' do
      '<form action="/submit/facebook" method="post">
      <input type="submit" value="Submit" />
      </from>'
    end
    
    get '/favicon.ico' do
      send_file "favicon.ico"
    end
    
    
   not_found do
    'Pas moyen de trouver ce que vous cherchez'
  end
  
   error do
    'mais une '
  end
  
  get '/*.*' do |chemin, ext|
    [chemin, ext] # => ["path/to/file", "xml"]
  end
  
  get '/*'  do
    "error"
  end
  
  post '/*'  do
    "Unknow path!!"
  end
  
  
  
end
