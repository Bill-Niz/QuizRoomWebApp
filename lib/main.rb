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
load "class/mail_helper.rb"
require 'pony'




port_web = 4444
port_chat = 5555

 thread_web = Thread.new(port_web) { 
  
  w = WebAppServer.new(port=port_web)
  
}
thread_chat = Thread.new { 
  
  q = ChatServer.new(port_chat)
  
}
thread_web.join()
thread_chat.join()



#option = {
#     :address        => 'relay.skynet.be',
##     :port           => '25',
##     :user_name      => '',
##     :password       => '',
##     :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
##     :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
#   }
#
#puts Pony.mail(:from => 'bill.nizeyimana@quizroom.com', :subject => 'Recovery Password',:to => 'hust.kmeleon@gmail.com',:html_body => '<h1>Hello there!</h1>', :body => "In case you can't read html, Hello there.", :via => :smtp, :via_options => option)


