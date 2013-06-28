module Value
  module Validator
    class NonNegativeNumberValidator < ActiveModel::EachValidator
      def validate_each(object, attribute, value)
        begin
          if value.present? && value.scalar.to_f < 0
            object.errors.add attribute, (options[:message] || 
                                          I18n.translate('errors.negative_val'))
          end
        rescue
          object.errors.add attribute, (options[:message] || 
                                        I18n.translate('errors.not_a_number'))
        end
      end
    end
  end # module Validator
end # module Value

