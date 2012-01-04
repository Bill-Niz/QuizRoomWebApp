# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
load 'class/submit.rb'

class TestSubmit < Test::Unit::TestCase
  def test_foo
    #TODO: Write test
    #flunk "TODO: Write test"
    # assert_equal("foo", bar)
  end
  
  def test_checkUser
    userNormal = Hash["email" => "user@mail.com",
                     "password" => "sha512",
                     "lastname" => "name",
                     "firstname" => "lastname",
                     "birthdate" => "2011-12-23 23:23:29",
                     "uuid" => "UUID"
                     ]
                   
     userFb = Hash["email" => "userFB@mail.com",
                     "password" => "sha512",
                     "lastname" => "name",
                     "firstname" => "lastname",
                     "birthdate" => "2011-12-23 23:23:29",
                     "uuid" => "UUID",
                     "facebook_id" => 12345,
                     "access_token" => "token",
                     "access_token_expiration" => "2011-12-23 23:23:29"]
    
     
    normalSub = Submit.new(userNormal, 'normal')
    fbSub = Submit.new(userFb, 'facebook')
    assert_not_nil(fbSub)
    assert_not_nil(normalSub)
    assert_equal('{"succes":"ok"}',normalSub.proceedSubmit)
    assert_equal('{"succes":"ok"}',fbSub.proceedSubmit) 
  end
end
