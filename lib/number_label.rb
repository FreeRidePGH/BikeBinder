class NumberLabel
  
  def initialze(number, prefix_str, delimiter_str, scope)
    @prefix = prefix
    @delimiter = delimiter
    @scope = scope
    @number = number
  end
  
  attr_reader :number

  include NumberLabelMethods

end # class NumberLabel

module NumberLabelMethods

  def self.included(base)
    base.extend ClassMethods
  end

  def label
    "#{@prefix}#{@delimiter}#{self.number}"
  end

  module ClassMethods
    def extract_number(label)
      arr = label.split(@delimiter) if label
      id = arr[-1] if arr.count > 1
      return id
    end

    def find_by_label(label)
      id = extract_number(label, @delimiter)
      @scope.find_by_number(id)
    end
  end
end
