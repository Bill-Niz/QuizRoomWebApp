# To change this template, choose Tools | Templates
# and open the template in the editor.
require "dbi"


class MysqlHelper
  DB_NAME = "QuizRoom"  # => Data base Name
  USER_TABLE = "user"   # => User table name in DB
  CHANNEL_TABLE = "channel"
  CLIENT_DB_USER = "QRClient"
  CLIENT_DB_PASSWORD = "USVtPeTbMsxEcMmn"
  DB_ADRESS = "localhost"
  
  def initialize(host=DB_ADRESS,user=CLIENT_DB_USER,password=CLIENT_DB_PASSWORD,db=DB_NAME)
    @host = host
    @user = user
    @password = password
    @dataBase = db
    @dbh
    @connected = false
    
  end
  
  
  ##
  #
  # Connection to the DB server
  #
  ##
  def connect
    
    if !self.connected?
   
     # connect to the MySQL server
     @dbh = DBI.connect("DBI:Mysql:#{@dataBase}:#{@host}", 
	                    "#{@user}", "#{@password}")
     @connected=true
    
  end
  end
  
  ##
  #
  # Check if we are connected to the  DB server
  #
  ##
  def connected?
    @connected
  end
  
  
  ##
  #
  #Check if a data is in DB
  #
  # - table : the table where data is
  # - column : the column name to checke
  # - dataToCheck : the data that have to be compared
  #
  ##
  def isInDB(table,column,dataToCheck)
    
    begin
    
    query = "SELECT * FROM `#{table}` WHERE `#{column}` = ?"
    isIn = true
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(dataToCheck)
    count=0
     sth.fetch { |row|  
       puts row[0]
       count+=1
     } 
      isIn = false if count==0
      puts count
    
    sth.finish
    
    rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
     @dbh.rollback
    rescue Exception => e  
      puts "error!!! -> : #{e.to_s}"
    
    ensure
     # disconnect from server
     @dbh.disconnect if @connected
     @connected=false
    end
    return isIn
      
  end
  
  ##
  #
  # Inster user into the DB
  ##
  def insertUser(email,password,lastname,firstname,birthdate,uuid,fbid,access_token,access_token_expiration)
    begin
    success= false
    query = "INSERT INTO `QuizRoom`.`user` (`email`, `password`, `last_name`, 
                                            `first_name`, `birthdate`, `uuid`,
                                            `facebook_id`, `access_token`, 
                                            `access_token_expiration`) 
                                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    sth =@dbh.prepare(query)
    sth.execute(email,password,lastname,firstname,birthdate,uuid,fbid,access_token,access_token_expiration)
    sth.finish
    @dbh.commit
   
    success = true
    rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
     @dbh.rollback
     rescue Exception => e  
      puts "error!!! -> #{e.to_s}"
    ensure
     # disconnect from server
     @dbh.disconnect if @connected
     @connected=false
    end
    
    return success
    
  end
  
end
