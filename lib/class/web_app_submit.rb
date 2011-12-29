# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'sinatra/base'
require 'json'
load 'submit.rb'

##
# Handle users registration
##
class WebAppSubmit < Sinatra::Base
  
 enable :sessions
 
  
  post '/submit/:method' do
      request.body.rewind
      data = JSON.parse request.body.read
      
      case params[:method]
      when 'facebook'
        
        puts params[:method]
        '{"state":"success"}'
       
      when 'normal'
        #puts data
        '{"state":"success"}'
        
      else
        '{"error":"Unknow method : #{params[:method]}"}'
        
      end
     
      
   end
end
