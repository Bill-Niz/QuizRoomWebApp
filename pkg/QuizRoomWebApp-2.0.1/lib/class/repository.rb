# To change this template, choose Tools | Templates
# and open the template in the editor.

=begin
This is a comment line
it explains that the next line of code displays 
a welcome message
=end
class Repository
  def initialize
    @contents = []
    @listeners = []
  end
  
  #
  # Add a new content in Array
  #
  def add(content)
    @contents << content
    self.fireContentsChanged(content)
    self.fireContentsAdded(content)
  end
  #
  # Remove the content passed in arg
  #
  def remove(content)
    @content.delete(content)
    self.fireContentsChanged(content)
    self.fireContentsChanged(content)
  end
  #
  # Get contents
  #
  def getcontents()
    @contents
  end
  #
  # Add listener to listner list
  #
  def addContentChangedListener(listener)
    
    @listeners << (listener)
  end
  #
  # Remove listener to listner list
  #
  def removeContentChangedListener(listener)
    @listeners.delete(listener)
  end
  
  
  
  
  #
  # Fire Contents changed event
  #
  def fireContentsChanged(data)
    @listeners.each() { |listener|  
      
       if ContentChanged.class === listener.class
         listener.onContentChanged(self,data)
      end
      }
    
  end
  #
  # Fire Contents added event
  #
  def fireContentsAdded(data)
    @listeners.each() { |listener|  
      
       if ContentChanged.class === listener.class
         listener.onContentAdded(self,data)
      end
      }
    
  end
  #
  # Fire Contents removed event
  #
  def fireContentsRemoved(data)
    @listeners.each() { |listener|  
      
       if ContentChanged.class === listener.class
        listener.onContentRemoved(self,data)
      end
      }
    
  end
  
  
  
end
