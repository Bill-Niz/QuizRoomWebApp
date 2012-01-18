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
 def initialize(app)
      @app = app
    end
  
   
  
  post '/submit/:method' do
      request.body.rewind
      data = JSON.parse request.body.read
      
      case params[:method]
      when 'facebook'
        #TODO Check DATA validity!
        s = Submit.new(data, 'facebook')
        s.proceedSubmit
       
      when 'normal'
        #TODO Check DATA validity!
         s = Submit.new(data, 'normal')
         s.proceedSubmit
        
      else
        '{"error":"Unknow method",
          "messafe":"Unknow method; Should be "facebook" or "normal""}'
        
      end
     
      
   end
   
 run! if app_file == $0
end

