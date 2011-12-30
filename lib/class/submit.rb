# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
load "mysql_helper.rb"
class Submit
  
  ##
  #
  #     Normal method
  #
  # userData = {"email" => "user@mail.com",
  #             "password" => "sha512",
  #             "lastname" => "name",
  #             "firstname" => "lastname",
  #             "birthdate" => "10/10/1989",
  #             "uuid" => "UUID"
  #             
  #             }
  #             
  #       Facebook method 
  #            
  # userData = {"email" => "user@mail.com",
  #             "password" => "sha512",
  #             "lastname" => "name",
  #             "firstname" => "lastname",
  #             "birthdate" => "10/10/1989",
  #             "uuid" => "UUID",
  #             "facebook_id" => "fb_id"
  #             "access_token" => "token",
  #             "access_token_expiration" => "token_expiration"
  #             }
  #
  ##
  
  ERROR_UNKNOWN_METHOD = '{"error":"Unknown method"}'
  SUCCESS_USER_REGISTERED = '{"succes":"ok"}'
  ERROR_USER_NOT_REGISTERED = '{"error":"fail"}'
  ERROR_USER_EXIST = '{"error":"user already exist"}'
  
  def initialize (data ,method)
    @userData = data
    @method = method
    @mysqlHelper = MysqlHelper.new
    
    
  end
  
  ##
  # Start user submision
  ##
  def proceedSubmit
    
    case @method
    when "facebook"
     
      if !checkUser
        
      
          unless @mysqlHelper.insertUser(@userData['email'], 
                              @userData['password'],
                              @userData['lastname'], 
                              @userData['firstname'], 
                              @userData['birthdate'], 
                              @userData['uuid'],
                              @userData['facebook_id'], 
                              @userData['access_token'], 
                              @userData['access_token_expiration'])
                            then
                            ERROR_USER_NOT_REGISTERED
          else
            SUCCESS_USER_REGISTERED
     end
     
      else
        ERROR_USER_EXIST
      end
      
    when "normal"
      
      if !checkUser
      unless @mysqlHelper.insertUser(@userData['email'], 
                              @userData['password'],
                              @userData['lastname'], 
                              @userData['firstname'], 
                              @userData['birthdate'], 
                              @userData['uuid'],
                              '', 
                              '', 
                              '') 
                            then
                            ERROR_USER_NOT_REGISTERED
      else
        SUCCESS_USER_REGISTERED
      end
      else
        ERROR_USER_EXIST
      end
      
    else
      ERROR_UNKNOWN_METHOD
    end
  end

  ##
  # Check if the user is already in the DataBase
  ##
  def checkUser
    
    @mysqlHelper.isInDB(MysqlHelper::USER_TABLE, "email", @userData['email'])
  end
  
  
  
end

