# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
require 'web_app_submit.rb'
require 'class/chat_handler'




class WebAppServer < Sinatra::Base
  
  def initialize(port = 8443,cert_path = 'ssl/')
    super(self)
    @port = port
    @CERT_PATH = cert_path
    @mysqlHelper = MysqlHelper.new
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
   
  #
  # Logging section
  #
  before do
    @start= Time.now
    if(request.path.include?'api')
      if(params["uuid"] == nil || !@mysqlHelper.isInDB(MysqlHelper::USER_TABLE, "uuid", params["uuid"]))
        halt '{"error":"Unknow user",
          "message":"Unknow uuid !"}'
      end
      
    end
        
       
  end
  
  after do
    @end = Time.now
    elps = ((@end-@start)*10000.0).to_int
    puts "Request from #{request.ip} in #{elps}mns. Size : #{response.body}"
  end
  
  
  #
  # Submit Section submit
  #
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
            "message":"Unknow method; Should be "facebook" or "normal""}'

        end
     
      
    end
    #
    # Login section
    #
    get "/login/:method" do
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
            "message":"Unknow method; Should be "facebook" or "normal""}'

        end
    end
  
    get '/api/channel' do
       
    chatHandler = ChatHandler.new
    JSON chatHandler.getChannelList
           
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
  
  get '/telecharger/*.*' do
    # répond à /telecharger/chemin/vers/fichier.xml
    params[:splat] # => ["chemin/vers/fichier", "xml"]
  end
  
  
  
  
  
  get '/*'  do
    
    "Unknow path!!"
  end
  
  post '/*'  do
    "Unknow path!!"
  end
  
  
  
end
