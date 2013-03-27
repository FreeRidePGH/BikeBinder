class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :rememberable
  devise(:database_authenticatable,
         :recoverable, 
         :trackable, 
         :validatable)
end
