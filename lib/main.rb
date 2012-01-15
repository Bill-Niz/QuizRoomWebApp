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
load "class/log.rb"




#w = WebAppServer.new(port=4444)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
#q = ChatServer.new(4444)

t = UserHandler.new
Log::logHttpsRequest(0, "192.102.1.1", 30, 40)


