# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
load "mysql_helper.rb"

class UserHandler
  def initialize(uuid)
    @uuid = uuid
  end
end
