class User < ActiveRecord::Base
  enum :group => [:guest, :volunteer, :staff, :coordinator, :admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :rememberable, :recoverable 
  devise(:database_authenticatable,
         :trackable, 
         :validatable)
end
