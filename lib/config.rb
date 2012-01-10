# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'sinatra'

#class Stream < Sinatra::Base
  get '/' do
    content_type :txt

    stream do |out|
      out << "It's gonna be legen -\n"
      sleep 2
      out << " (wait for it) \n"
      sleep 5
      out << "- dary!\n"
    end
  end
#end

#run Stream
