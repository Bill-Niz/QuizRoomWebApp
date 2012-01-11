# To change this template, choose Tools | Templates
# and open the template in the editor.
$:.unshift File.join(File.dirname(__FILE__),'..','class')

class ChatHandler
  def initialize
    @mysqlHelper = MysqlHelper.new
  end
  
  
  #
  # Return an array of hash channels  
  # 
  # [{ "name"=>"chan_name", 
  #   "id"=>"456422", 
  #   "connected"=>"1", 
  #   "user_list"=>[{"uuid"=>"123456", 
  #                 "last_name"=>"Doe", 
  #                 "first_name"=>"Jhon", 
  #                 "img_url"=>"http://pic.com/pic.png"}]
  # },...]
  #
  def getChannelList()
    chanList = @mysqlHelper.getChannelList
    
    chanList.each { |chan| 
      userlist = self.getUserListInChannel(chan["id"])
      chan["connected"] = userlist.count
      chan["user_list"] = userlist
    }
    chanList
  end
  #
  # Return the list of user in a channel
  #
  def getUserListInChannel(idChannel)
    @mysqlHelper.getUserListInchannel(idChannel)
  end
end
