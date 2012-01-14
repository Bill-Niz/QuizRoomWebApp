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
load "class/user_handler.rb"




#w = WebAppServer.new(port=4444)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
#q = ChatServer.new(4444)

t = UserHandler.new
u = Hash["email" => "userFB@mail.com",
                     "password" => "sha512",
                     "lastname" => "name",
                     "firstname" => "lastname",
                     "birthdate" => "2011-12-23 23:23:29",
                     "uuid" => "UUID",
                     "facebook_id" => 12345,
                     "access_token" => "token",
                     "access_token_expiration" => "2011-12-23 23:23:29"]
v =  Hash["email" => "userFB@mail.com",
                     "password" => "sha512",
                     "lastname" => "name",
                     "firstname" => "lastname",
                     "birthdate" => "2011-12-23 23:23:29",
                     "uuid" => "UUID",
                     "facebook_id" => 12345,
                     "access_token" => "token_",
                     "access_token_expiration" => "2011-12-23 23:23:29"]                  
mysql = MysqlHelper.new

#puts mysql.getUserInfo("-2")

def is_a_number?(s)
  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
end
puts is_a_number?(5)
puts is_a_number?("+256.375")
puts is_a_number?("-37.3")
puts is_a_number?("x")
puts is_a_number?(-37.3)
puts is_a_number?("2.3.3")

#t.checkFbToken(100000096947433, "BAAESltcZAKeYBAP4axCBJlWPr69Md1s9wxJBHPVjjA85ZCcWx5bIhHje7nu7ZBKYIVtdCZCibp7Jr48Mgmh0M4S7ZAjD2VZCoulZCZBZCAgHCRE2KijarawA1CrZC1K7DlKjdo5n6VIjgr7gZDZD")

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


