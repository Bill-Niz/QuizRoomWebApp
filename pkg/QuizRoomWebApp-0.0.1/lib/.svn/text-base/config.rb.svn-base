# To change this template, choose Tools | Templates
# and open the template in the editor.

CERT_PATH = '/Users/kmeleon/NetBeansProjects/QuizRoomWebApp/lib/ssl/'

webrick_options = {
        :Port               => 8443,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => "/ruby/htdocs",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(File.open(File.join(CERT_PATH,"server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(File.open(File.join(CERT_PATH,"server.key")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

class MyServer  < Sinatra::Base
    post '/' do
      "Hellow, world!"
    end
    get '/' do
      "Hellow, world!"
    end  
end

Rack::Handler::WEBrick.run MyServer, webrick_options
 

 
 
