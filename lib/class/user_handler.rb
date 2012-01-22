# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
#load "mysql_helper.rb"
require 'uri'
require 'net/http'
require 'json'

class UserHandler
  
  ERROR_UNKNOWN_METHOD = '{"error":"Unknown method"}'
  ERROR_USER_NOT_LOGIN = '{"error":"Unkow user or password"}'
  LINK_FACEBOOK_GRAPH = 'https://graph.facebook.com/?fields=id&access_token='
  
  def initialize()
    @uuid 
    @mysqlHelper = MysqlHelper.new
    @expiration_time = 2   #in Hours
    
  end
  
  
  
  #
  # Update user info 
  # 
  # info Format
  # ____________
  # 
  # [« last_name » =>  « last_name »,
  #« first_name » => « first_name »,
  #« birthdate » => 2012-01-10,
  #« profile_img » =>  «profile_img»
  #]
  #
  #
  def udateInfo(uuid,hashInfo)
    #TODO : Check if keys are valid
    
    hashInfo.each(){|key,value|
      
      @mysqlHelper.updateUserInfo(uuid,key, value)
    }
    
  end
  #
  # Generate access token with expiration data
  # {
  #   "uuid" => "UUID",
  #   "access_token" => "token",
  #   "access_token_expiration" => "token_expiration"
  # }

  def genToken
    token = Utility::genToken(64)
    token_expiration = Time.now
    token_expiration += @expiration_time * 60 * 60
    
    tokenInfo = Hash["uuid" => "#{@uuid}",
         "access_token" => "#{token}",
         "access_token_expiration" => token_expiration
        ]
        self.udateInfo(@uuid,tokenInfo)
    return tokenInfo
    
    
  end
  #
  #Login the user and return acces token
  #
  #method : facebook | normal
  #
  # userInfo : Normal :
  #
  #{"email" => "user@mail.com",
  #  "password" => "sha512",
  #}
  #
  #Facebook :
  #
  #  {
  #     "facebook_id" => "fb_id",
  #     "fb_access_token" => "token",
  #     "fb_access_token_expiration" => "token_expiration"
  # }
  # 
  # 
  #return access token : 
  # {
  #   "uuid" => "UUID",
  #   "access_token" => "token",
  #   "access_token_expiration" => "token_expiration"
  # }
  #
  #
  def login(method,userInfo)
    
    case method
      
      when 'facebook'
        uuid = @mysqlHelper.loginFacebook(userInfo)
        if uuid
          @uuid = uuid
          token = self.genToken
          JSON token
        else
          
        end
        ERROR_USER_NOT_LOGIN
        
      when 'normal'
        uuid = @mysqlHelper.loginNormal(userInfo)
        if uuid
          @uuid = uuid
          token = self.genToken
          JSON token
        else
          
        end
        ERROR_USER_NOT_LOGIN
        
      else
        ERROR_UNKNOWN_METHOD 
      end
  end
  
  #
  #Check if the access token given is valid for
  # the user id given
  # 
  # if valid, facebook graph send : 
  # 
  # {
  # 
  #   "id": "100000096947433"
  # }
  # 
  # If not : 
  # 
  # {
  #   "error": {
  #      "message": " A message ",
  #      "type": "OAuthException"
  #   }
  # }
  # 
  # 
  # 
  #
  def checkFbToken(idUser,fbToken)
    url ="https://graph.facebook.com/#{idUser}?fields=id&access_token=#{fbToken}"
    uri = URI.parse( url )
     begin
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      #http.enable_post_connection_check = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      http.cert_store = store
      http.start {
        response = http.get(uri.path)
        puts  response.body if !response.nil?
      }
     rescue => e
       puts e.to_s
   
     end
     
    
  end
  
end
