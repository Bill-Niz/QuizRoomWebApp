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


#w = WebAppServer.new(port=4444)


#port = 4444
#srv = ChatServer.new(port)



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
  
j = u.to_json
puts u['password'] == nil


#o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten 
#map =  (0..8).map{o[rand(o.length)]}.join;
#
#puts map
