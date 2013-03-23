module NumberSlug

  class Slug

    # @param [#number, String]
    # 
    def initialize(sluggable, options={})

      is_record = sluggable.respond_to?(:number)
      is_invertable = options[:invert].present?

      @scope = is_record ? sluggable.class : sluggable
      @config = @scope.number_slug_config 
      @prefix = @config.prefix
      @delimiter = @config.delimiter

      if is_record
        # Model with a number
        @number = sluggable.number
      elsif is_invertable
        # Pre-slugged string that needs to be inverted into a slug instance
        @number = extract_number(options[:invert])
      end
    end

    attr_reader :number

    def to_s
      "#{@prefix}#{@delimiter}#{@number}"
    end

    private

    def extract_number(slug_str)
      arr = slug_str.split(@delimiter) if slug_str
      num = arr[-1] if arr.count > 1
      return num
    end
    
  end # class Slug

  class Configuration
    attr_accessor :prefix, :delimiter, :scope

    def initialize(scope, values=nil)
      @scope = scope
      set values
    end

    private

    def set(values)
      values and values.each {|name, value| self.send "#{name}=", value}
    end
  end

  def self.extended(base)
    base.instance_eval do
      extend Base
      @number_slug_config = Class.new(Configuration).new(self)
    end
  end

  module Base
    def number_slug(format, &block)    
      yield number_slug_config if block_given?
      number_slug_config.send :set, format
      
      include InstanceMethods
      extend ClassMethods
    end

    def number_slug_config
      @number_slug_config  || base_class.number_slug_config.dub.tap do |config|
        config.scope = self
      end
    end
  end
  
  module ClassMethods
    def number_from_slug(slug)
      Slug.new(number_slug_config.scope, :invert => slug).number
    end

    def find_by_slug(slug)
      number_slug_config.scope.
        where{number.in [my{number_from_slug(slug)}, my{slug}]}.first
    end
  end

  module InstanceMethods
    def slug
      Slug.new(self).to_s
    end
  end
end
