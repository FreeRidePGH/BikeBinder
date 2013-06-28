class BikeNumberValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value.to_s =~ BikeNumber.anchored_pattern
      object.errors.add attribute, (options[:message] || I18n.translate('errors.invalid_format'))
    end 
  end
end

class BikeNumber

  include ActiveModel::Validations

  def initialize(number)
    @n = number
  end

  def to_s
    @n.to_s
  end

  def self.pattern
    return /\d{5}/
  end

  def self.format_number(num)
    return sprintf("%05d", num.to_i) if num
  end

  def self.anchored_pattern
    return Regexp.new('\A'+self.pattern.source+'\z')
  end

  validates :to_s, :bike_number => :true

end
