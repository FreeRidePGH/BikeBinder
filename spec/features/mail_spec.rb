require 'spec_helper'

describe "sending mail" do
  
  context "with configuration" do
    let(:to){"testappmail@mailinator.com"}
    let(:message){ActionMailer::Base.mail(:from => "test@test.org",
                                          :to => to, :subject => "Test Mail")}
    before :each do
      BikeBinder::Application.configure do
        require 'tlsmail' # http://yekmer.posterous.com/devise-gmail-smtp-configuration
        Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE) 
        
        config.action_mailer.delivery_method = :smtp
        config.action_mailer.raise_delivery_errors = true
        config.action_mailer.perform_deliveries = true
        config.action_mailer.default_url_options= {:host => 'localhost:3000'}
        
        if File.exists?(APP_MAILER_CONFIG_FILE)
          require APP_MAILER_CONFIG_FILE
          config.action_mailer.smtp_settings = MailerConfig::settings
        end
      end
    end # before :each

    after :each do
      BikeBinder::Application.configure do
        config.action_mailer.delivery_method = :test
      end
    end

    it "sends mail", :if => false do
      expect(message.deliver).to be_true
    end
  end

end
