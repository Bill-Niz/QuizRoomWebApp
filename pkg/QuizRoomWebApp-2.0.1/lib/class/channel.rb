# To change this template, choose Tools | Templates
# and open the template in the editor.
load "module/content_changed.rb"
class Channel
  include ContentChanged
  
  def initialize(name="",id="")
    @userList = UserRepository.new
    @name = name
    @id = id
    @userList.addContentChangedListener(self)
    @mysqlHelper = MysqlHelper.new(MysqlHelper::DB_ADRESS,"root","root",MysqlHelper::DB_NAME)
  end
  
  
  #
  # Return the list of user in the channel
  #
  def getUserList
    @userList
  end
  
  #
  # Return the name of the channel
  #
  def getName
    @name
  end
  #
  # Return the id of the channel
  #
  def getId
    @id
  end
  #
  # Add user in the channel
  #
  def join(user)
    @mysqlHelper.insertConUser(user.getI,@id)
    @userList.getcontents.each { |users| 
      
      users.userChangeFromChannel("204", @id, user.getId)
    }
    @userList.add(user)
    
  end
  #
  # Remove user from the channel
  #
  def remove(user)
    if(self.isIn(user))
      @mysqlHelper.deleteDisConUser(user.getI, @id)
      @userList.remove(user)
      @userList.getcontents.each { |users|
        users.userChangeFromChannel("205", @id, user.getId)
      }
    end
  end
  #
  # Send message to all users in this channel
  #
  def send(fromIdUser,msg)
    #TODO : add exception for the sender!
    @userList.getcontents.each { |user| 
    
      user.receiveFromChannel(@id, fromIdUser, msg)
      
    }
  end
  #
  # Check if an user is in the channel
  #
  def isIn(user)
    
    isIn = false
    @userList.getcontents.each { |users| 
    
      if(user == users)
        isIn = true
        break
      end
      
    }
    return isIn
  end
  #
  #
  #
  def onContentChanged(source,data)
    
  end
  #
  #
  #
  def onContentAdded(source,data)
    
  end
  #
  #
  #
  def onContentRemoved(souce,data)
    
  end
  #
  #
  #
  def to_s
    "Channel : Name = #{@name} Id = #{@id}"
  end
end
