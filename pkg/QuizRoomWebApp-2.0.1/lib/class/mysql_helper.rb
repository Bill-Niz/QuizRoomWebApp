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
  LOG_TABLE = "serverLog"
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
     
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(dataToCheck)
    count=0
    isIn=false
     sth.fetch() { |row|  
       
       count+=1
       isIn=row[0]
     } 
      #isIn = false if count==0
      
    
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
    query = "INSERT INTO `#{DB_NAME}`.`#{USER_TABLE}` (`email`, `password`, `last_name`, 
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
  
  
  #######################################################
  #                                                     #
  #                   CHAT HANDLING                     #
  #                                                     # 
  #######################################################
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
    query = "SELECT id_user,last_name,first_name,profile_img FROM `#{USER_TABLE}` 
             INNER JOIN #{USER_LIST_IN_CHAN_TABBLE} 
                  ON #{USER_TABLE}.id_user = #{USER_LIST_IN_CHAN_TABBLE}.user_id_user 
                  WHERE #{USER_LIST_IN_CHAN_TABBLE}.channel_id_channel  = #{idChan}"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute()
    
     sth.fetch { |row|  
       userlList << Hash["id" => row[0],
                          "last_name" =>  to_utf8(row[1]),
                          "first_name" =>  to_utf8(row[2]),
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
  
  #
  # Insert Connected user in to channel
  #
  def insertConUser(idUser,idChannel)
    
    begin
      query = "INSERT INTO `#{DB_NAME}`.`#{USER_LIST_IN_CHAN_TABBLE}` (`user_id_user`, `channel_id_channel`) 
                                                                       VALUES (?, ?)"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)

    sth.execute(idUser,idChannel)
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
  end
  #
  # delete disconnected user in to channel
  #
  def deleteDisConUser(idUser,idChannel)
    
    begin
      query = "DELETE FROM `#{DB_NAME}`.`#{USER_LIST_IN_CHAN_TABBLE}` WHERE `#{USER_LIST_IN_CHAN_TABBLE}`.`user_id_user` = ? AND `#{USER_LIST_IN_CHAN_TABBLE}`.`channel_id_channel` = ?"
      queryReset = "ALTER TABLE #{USER_LIST_IN_CHAN_TABBLE} AUTO_INCREMENT = 1"
      self.connect unless self.connected?  # => connect to the DB server if not connected
      sth = @dbh.prepare(query)
      sth.execute(idUser,idChannel)
      sth = @dbh.prepare(queryReset)
      sth.execute
      
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
    
      
  end
  
  #####################################################
  #                                                   #
  #                   USER HANDLE                     #
  #                                                   # 
  #####################################################
  
  #
  # Update user info with column name / data
  #
  def updateUserInfo(uuid,colname,info)
    
    begin
      query = "UPDATE  `#{DB_NAME}`.`#{USER_TABLE}` SET  `#{colname}`  =  ? WHERE  `user`.`uuid` = ?;"
      self.connect unless self.connected?  # => connect to the DB server if not connected
      sth = @dbh.prepare(query)
      sth.execute(info,uuid)
     
      
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
    
      
  end
  
  
  
  
  #
  #
  # Try to login an user with login and password
  # 
  # Return : UUID of the user Or FALSE
  #
  #
  def getUserInfo(idUser)
    
    begin
    
    query = "SELECT last_name,first_name,email,birthdate,facebook_id,profile_img FROM `#{USER_TABLE}` WHERE `id_user` = ?"
     
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(idUser)
    count=0
    userinf=false
    sth.fetch() { |row|  
      userinf = Hash["last_name" => self.to_utf8(row[0]),
                      "first_name" => self.to_utf8(row[1]),
                      "email" => row[2],
                      "birthdate" => row[3],
                      "facebook_id" => row[4],
                      "profile_img" => row[5]]
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
    return userinf
      
  end
  
  
  #
  #
  # Try to login an user with login and password
  # 
  # Return : UUID of the user Or FALSE
  #
  #
  def loginNormal(userInfo)
    
    begin
    
    query = "SELECT uuid FROM `#{USER_TABLE}` WHERE `email` = ? AND `password` = ?"
     
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(userInfo["email"],useInfo["password"])
    count=0
    isIn=false
    sth.fetch() { |row|  
       isIn=row[0]
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
    return isIn
      
  end
  
  
  
  ##
  #
  #
  #
  ##
  def loginFacebook(userInfo)
    
    begin
    
    query = "SELECT uuid FROM `#{USER_TABLE}` WHERE `faceboo_id` = ?"
     
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(userInfo["faceboo_id"])
    count=0
    isIn=false
    sth.fetch() { |row|  
       isIn=row[0]
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
    return isIn
      
  end
  #
  # Check the validity of uuid with access token
  #
  #
  def validAccessToken(accessInfo)
    
    begin
    
    query = "SELECT uuid FROM `#{USER_TABLE}` WHERE `uuid` = ? AND `access_token` = ? AND `access_token_expiration` > NOW()"
     
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)
    
    sth.execute(accessInfo["uuid"],accessInfo["token"])
    count=0
    isIn=false
    sth.fetch() { |row|  
       isIn=row[0]
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
    return isIn
      
  end
  
  #####################################################
  #                                                   #
  #                   LOG HANDLER                     #
  #                                                   # 
  #####################################################
  
  #
  #
  #
  def log(uuid,ipsource,responseTime,responseSize)
    begin
      query = "INSERT INTO `#{DB_NAME}`.`#{LOG_TABLE}` (`uuid`, `ip_address`,`response_time`,`response_data_size`) 
                                                                       VALUES (?, ?, ?, ?)"
    
    self.connect unless self.connected?  # => connect to the DB server if not connected
    
    sth = @dbh.prepare(query)

    sth.execute(uuid,ipsource,responseTime,responseSize)
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
  end
  
end
