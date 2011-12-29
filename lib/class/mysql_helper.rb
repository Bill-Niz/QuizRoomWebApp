# To change this template, choose Tools | Templates
# and open the template in the editor.
require "dbi"


class MysqlHelper
  def initialize
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
    begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:#{@dataBase}:#{@host}", 
	                    "#{@user}", "#{@password}")
     @connected=true
    
    rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
    ensure
     # disconnect from server
     dbh.disconnect if dbh
     @connected=false
    end
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
    query = "SELECT ? FROM ? WHERE ? = ?"
    isIn = false
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth =@dbh.prepare(query)
    
    sth.execute(column,table,column,dataToCheck)
    
    if sth.size >=1
      isIn = true
    end
    sth.finish
    
    puts "Record has been created"
    @dbh.disconnect
    isIn
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
    @dbh.disconnect
    puts "User has been created"
    success = true
    rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
     @dbh.rollback
    ensure
     # disconnect from server
     @dbh.disconnect if @dbh
     success = false
    end
    
    return success
    
  end
  
end
