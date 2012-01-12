# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
load "mysql_helper.rb"

class UserHandler
  
  ERROR_UNKNOWN_METHOD = '{"error":"Unknown method"}'
  ERROR_USER_NOT_LOGIN = '{"error":"Unkow user or passeword"}'
  ERROR_USER_EXIST = '{"error":"user already exist"}'
  
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
  #« uuid » =>  « uuid »,
  #« facebook_id » => « fbk_id »,
  #« access_token » =>  « acces_t »,
  #« acces_token_expiration » =>  « ate»,
  #« profile_img » =>  « profile_img »
  #]
  #
  #
  def udateInfo(hashInfo)
    #TODO : Check if keys are valid
    
    hashInfo.each(){|key,value|
      
      @mysqlHelper.updateUserInfo(@uuid,key, value)
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
    
    Hash["uuid" => "#{@uuid}",
         "access_token" => "#{token}",
         "access_token_expiration" => token_expiration
        ]
    
    
  end
  #
  #Login the user and return acces token
  #
  #method : facebook | normal
  #
  # userInfo : Normal :
  #
  #{"email" : "user@mail.com",
  #  "password" : "sha512",
  #}
  #
  #Facebook :
  #
  #  {
  #     "facebook_id" : "fb_id",
  #     "fb_access_token" : "token",
  #     "fb_access_token_expiration" :"token_expiration"
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
        @mysqlHelper
        
      when 'normal'
        uuid = @mysqlHelper.loginNormal(userInfo)
        if uuid
          @uuid = uuid
          token = self.genToken
          token
        else
          
        end
        ERROR_USER_NOT_LOGIN
      else
        ERROR_UNKNOWN_METHOD 
      end
  end
  
end
