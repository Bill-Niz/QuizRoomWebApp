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
    @userList.getcontents.each { |users| 
      
      users.userChangeFromChannel("204", @id, user.getId)
    }
    @userList.add(user)
    
  end
  #
  # Remove user from the channel
  #
  def remove(user)
    @userList.remove(user)
    @userList.getcontents.each { |users| 
      
      users.userChangeFromChannel("205", @id, user.getId)
    }
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
