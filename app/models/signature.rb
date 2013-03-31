class Signature < ActiveRecord::Base

  attr_accessible :uname

  hound_user

  validates_uniqueness_of :uname, :allow_nil => false, :message => "Signature is not unique"
  
  def self.find_or_create(signature)
    return nil if signature.blank?
    s = self.where(:uname => signature).first
    s ||= self.create(:uname => signature)
  end
end
