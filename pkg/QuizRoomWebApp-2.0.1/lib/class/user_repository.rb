# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
load "repository.rb"
#
# Repository for users
#
class UserRepository < Repository
  def initialize
    super
  end
end
