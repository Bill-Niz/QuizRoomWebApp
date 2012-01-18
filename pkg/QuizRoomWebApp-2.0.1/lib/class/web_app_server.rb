# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
require 'web_app_submit.rb'
require 'class/chat_handler.rb'
require 'class/utility.rb'
require 'class/log.rb'




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
   
  #################################################
  #
  # Logging  and Access control section
  # 
  #
  
  before do
    @start= Time.now
    if(request.path.include?'api')
      self.validAccess
      end
        
  end
  
  after do
    @end = Time.now
    elps = ((@end-@start)*1000.0).to_int
    puts "Request from #{request.ip} in #{elps}mns. Size : #{response.body}"
    Log::logHttpsRequest(params["uuid"], request.ip, elps, response.body.length)
    
  end
  
  
  ###############################################
  #
  # Submit Section submit
  # 
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
    
    ############################################
    #
    # LOGIN SECTION
    # 
    #
    
    post "/login/:method" do
      request.body.rewind
      data = JSON.parse request.body.read
      
      case params[:method]
        when 'facebook'
          #TODO Check DATA validity!
          login = UserHandler.new
          login.login('facebook', data)

        when 'normal'
          #TODO Check DATA validity!
           login = UserHandler.new
          login.login('normal', data)

        else

          '{"error":"Unknow method",
            "message":"Unknow method; Should be "facebook" or "normal""}'

        end
    end
  
    ###########################################
    #
    # API SECTION
    # 
    #
    
   
    #
    #
    #
    get '/api/channel' do
       
    chatHandler = ChatHandler.new
    JSON chatHandler.getChannelList
           
    end
    
    #
    #Get user info with user id
    #
    #return
    #{
    #   « last_name » : « lastname »,
    #   « first_name » :« first_name »,
    #   « email » : « mail@me.com »,
    #   « birthdate » :2012-01-10,
    #   « facebook_id » : « fbk_id »,
    #   « profile_img » :  « profile_img »
    # }
    #
    get '/api/user' do
      
    if(params['user'] !=nil && Utility::is_a_number?(params['user']))
        userInfo = @mysqlHelper.getUserInfo(params['user'])
        if(userInfo)
          userInfo
        else
          '{"error":"Unknow user",
          "message":"Unknow id !"}'
        end
    else
      '{"error":"Unknow user",
          "message":"Unknow id !"}'
        
      end
      
    end
    
    #
    # Update user info
    # 
    # {
    #  « last_name » :  « last_name »,
    #  « first_name » : « first_name »,
    #  « birthdate » :2012-01-10,
    #  « profile_img » :  « profile_img »
    # }
    # 
    #
    post '/api/update' do
      
    end
    
    ###########################################
    #
    # DOWNLOAD SECTION
    # 
    #
    
    get '/telecharger/*.*' do
      # répond à /telecharger/chemin/vers/fichier.xml
      params[:splat] # => ["chemin/vers/fichier", "xml"]
    end
    
    #
    #
    #
    get '/favicon.ico' do
      send_file "favicon.ico"
    end
   
    #############################################
    #
    #
    # Recovery password section
    #
    #
    
    get '/recovery' do
      if(params['token'])
        
        puts request.user_agent 
        erb :index, :format => :html5 , :locals => {:token => params['token'], :agent => request.user_agent }
      else
        
      end
    end
    
    post '/recovery' do
      if(params['token'])
        password = Utility::sha512(params['psw'])
        puts password
      end
    end
  
    ###########################################
    #
    # UTILITY FUNCTIONS SECTION
    # 
    #
  
    def validAccess
      
      #Check
      if(params["uuid"] == nil || ! @mysqlHelper.isInDB(MysqlHelper::USER_TABLE, "uuid", params["uuid"]))
        halt '{"error":"Unknow user",
          "message":"Unknow uuid !"}'
      else
        isValid = @mysqlHelper.validAccessToken(params)
        if(!isValid)
          halt '{"error":"Access token not valid",
          "message":"Access token not valid or expired"}'
        end
      end
      
    end
  
    #########################################
    #
    # ERROR SECTION
    # 
    #
  
    not_found do
      '{"error":" Unknow Path!"}'
    end
  
    error do
      '{"error":"Something goes wrong :("}'
    end

    #
    #
    #
    get '/*'  do

      erb :index, :format => :html5
      '{"error" : " Unknow Path!"}'
    end
    
    #
    #
    #
    post '/*'  do
       '{"error" : " Unknow Path!"}'
    end

  end
  
 