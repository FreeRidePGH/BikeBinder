module MailerConfig

  def self.default_url_host
    "application.com"
  end


  def self.settings
    {
      :enable_starttls_auto => true,
      :address => 'mail.server.com',
      :port => 587,
      :authentication => :login,
      :domain => "domain.com",
      :user_name => "user@domain.com",
      :password => "passwordsecret"
    }
  end
end
