# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'net/smtp'

class MailHelper
  def initialize
    @smtpHost = 'relay.skynet.be'
    @smtpPort
    @smtpUser
    @smtpPsw
    @smtClient
    
  end
  
  def sendMail(toMail, fromMail)  
    message = <<MESSAGE_END
      From: Private Person <#{fromMail}>
      To: A Test User <#{toMail}>
      MIME-Version: 1.0
      Content-type: text/html
      Subject: SMTP e-mail test

    This is an e-mail message to be sent in HTML format

    <b>This is HTML message.</b>
    <h1>This is headline.</h1>
MESSAGE_END

Net::SMTP.start(@smtpHost) do |smtp|
  smtp.send_message message, fromMail, 
                             toMail
end
  end
  
end
