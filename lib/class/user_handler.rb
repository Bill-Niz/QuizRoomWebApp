# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')
load "mysql_helper.rb"

class UserHandler
  def initialize(uuid)
    @uuid = uuid
  end
  
  
  
  #
  # Update user info 
  # 
  # info Format
  # ____________
  # 
  # {« last_name » :  « last_name »,
  #« first_name » : « first_name »,
  #« birthdate » :2012-01-10,
  #« uuid » :  « uuid »,
  #« facebook_id » : « fbk_id »,
  #« access_token » :  « acces_t »,
  #« acces_token_expiration » :  « ate»,
  #« profile_img » :  « profile_img »
  #}
  #
  #
  def udateInfo(hashInfo)
    
  end
end
