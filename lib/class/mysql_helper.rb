# To change this template, choose Tools | Templates
# and open the template in the editor.
require "dbi"
require 'rubygems'
require 'active_support/all'
require 'iconv'


class MysqlHelper
  DB_NAME = "QuizRoom"  # => Data base Name
  USER_TABLE = "user"   # => User table name in DB
  USER_LIST_IN_CHAN_TABBLE = "listUserChannel"
  CHANNEL_TABLE = "channel"
  CATEGORIES_TABLE= "categories"
  LIST_USER_CHANNEL_TABLE = "listUserChannel"
  SERVER_LOG_TABLE = "serverLog"
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
       
       count+=1
     } 
      isIn = false if count==0
      
    
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
  #
  #
  #
  def to_utf8 string
    Iconv.iconv('UTF-8','ISO-8859-1', string)[0]
  end
  
  #
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
  #
  # Return the channels list
  #
  def getChannelList
    begin
    channelList = []
      query = "SELECT * FROM `#{CHANNEL_TABLE}`"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute()
    
     sth.fetch { |row|  
       channelList << Hash["id" => row[0], "name" =>  to_utf8(row[1])]
     } 
      
    
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
    return channelList
  end
  
  
  #
  # Return the channels list
  #
  def getUserListInchannel(idChan)
    begin
    userlList = []
    query = "SELECT uuid,last_name,first_name,profile_img FROM `#{USER_TABLE}` 
             INNER JOIN #{USER_LIST_IN_CHAN_TABBLE} 
                  ON #{USER_TABLE}.id_user = #{USER_LIST_IN_CHAN_TABBLE}.user_id_user 
                  WHERE #{USER_LIST_IN_CHAN_TABBLE}.channel_id_channel  = #{idChan}"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute()
    
     sth.fetch { |row|  
       userlList << Hash["uuid" => row[0],
                          "lastname" =>  to_utf8(row[1]),
                          "name" =>  to_utf8(row[2]),
                          "img_url" =>  row[3]
                          ]
     } 
      
    
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
    return userlList
  end
  
end
