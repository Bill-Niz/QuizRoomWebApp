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



u = Hash["email" => "user@mail.com",
             "password" => "sha512",
               "name" => "name",
               "lastname" => "lastname",
               "UUID" => "UUID"
]
  #puts userData['email'] 
  
j = u.to_json
puts j

