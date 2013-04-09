module MailerConfig
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
