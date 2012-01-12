# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'sinatra/base'
require 'json'
load "class/web_app_server.rb"
load "class/channel_repository.rb"
load "class/user_repository.rb"
load "class/user.rb"
load "class/chat_server.rb"
load "class/chat_handler.rb"
load "class/utility.rb"




#w = WebAppServer.new(port=4444)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    
t = "BAAE0N0Wh3YYBA EZCtxL4iC00XmELxczl7hfGX7GbdGawICcDQW9ekIwSp762uvp4Tt8Ttz2xDIEcD4550r4Ese96iIVvgwrpMZBZANOVdNBfMohRRriWvVdVSQpjjGm9UzFbaqHZAgZDZD"
a = "BAAE0N0Wh3YYBA EZCtxL4iC00XmELxczl7hfGX7GbdGawICcDQW9ekIwSp762uvp4Tt8Ttz2xDIEcD4550r4Ese96iIVvgwrpMZBZANOVdNBfMohRRriWvVdVSQpjjGm9UzFbaqHZAgZDZD"    
c = "BAAE0N0Wh3YYBA CJIWgAcGq59tG3SwgCn7Q6DTCovhUV4XuZCd7eS7mIsepDCm5sZA1rYcgRf5iybyq063jzxBlegTCRHXH7BvGvL4TbSEhDZBsgNsr8QphzXYYxImymtwN5hqBeBOWC7ArNW6ZCG"
puts rand(36**64).to_s(36)

u = Hash["email" => "userFB@mail.com",
                     "password" => "sha512",
                     "lastname" => "name",
                     "firstname" => "lastname",
                     "birthdate" => "2011-12-23 23:23:29",
                     "uuid" => "UUID",
                     "facebook_id" => 12345,
                     "access_token" => "token",
                     "access_token_expiration" => "2011-12-23 23:23:29"]
  #puts userData['email'] 
  
#c= ChatHandler.new

#puts JSON c.getChannelList


