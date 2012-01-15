# To change this template, choose Tools | Templates
# and open the template in the editor.

class Log
  def initialize
    
  end
  
  
  def self.logHttpsRequest(uuid,ipsource,responseTime,responseSize)
    mysql = MysqlHelper.new
    mysql.log(uuid,ipsource,responseTime,responseSize)
  end
end
