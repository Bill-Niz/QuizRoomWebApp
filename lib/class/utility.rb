# To change this template, choose Tools | Templates
# and open the template in the editor.

class Utility
  def initialize
    
  end
  
  #
  # Generate a unique random access token
  #
  def self.genToken(lenght)
    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten 
    map =  (0..lenght).map{o[rand(o.length)]}.join;
    return map
  end
end
