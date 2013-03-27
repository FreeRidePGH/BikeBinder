class HookNumberValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value.to_s =~ HookNumber.anchored_pattern
      object.errors.add attribute, (options[:message] || "is not formatted properly")
    end 
  end
end

class HookNumber

  include ActiveModel::Validations

  def initialize(number)
    @n = number
  end

  def to_s
    @n.to_s
  end

  def self.pattern
    return /\d{2}(H|L)/
  end

  def self.anchored_pattern
    return Regexp.new('\A'+self.pattern.source+'\z')
  end

  validates :to_s, :hook_number => :true

end
