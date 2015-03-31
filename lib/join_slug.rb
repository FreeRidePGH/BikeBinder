module JoinSlug

  class Slug

    # @param [#where, String]
    # 
    def initialize(sluggable, options={})
      
      is_record = slug_joins.respond_to?(:slug)
      is_invertable = options[:invert].present?

      @scope = is_record ? sluggable.class : sluggable
      @config = @scope.number_slug_config 

      @prefix = @config.prefix
      @delimiter = @config.delimiter
      
      if is_record
        # Join association
        # @join = 
      elsif is_invertable
        # Pre-slugged string that needs to be inverted into a slug instance
        @number = extract_number(options[:invert])
      end
    end

    attr_reader :join

    def to_s
      if @str.nil?
        @str = "#{@prefix}"
        join.each do |model, method|
          @str += "#{@delimiter}#{model.send(method)}"
        end
      end
      @str 
    end

    private

    def extract_joins(slug_str)
     # discard the prefix
      arr = slug_str.split(@delimiter)[1..-1] if slug_str
      return nil if arr.length < 1
      
      (0..arr.length).each do |i|
        join[i]
      end

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
  end # class Configuration

  def self.extended(base)
    base.instance_eval do
      extend Base
      @number_slug_config = Class.new(Configuration).new(self)
    end
  end

  module Base
    def join_slug(joins, &block)    
      yield number_slug_config if block_given?
      number_slug_config.send :set, joins
      
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

    # 
    # 
    def slugs_from_join(slug)

    end

    def number_from_slug(slug)
      Slug.new(number_slug_config.scope, :invert => slug).number
    end

    def find_by_slug(slug)
      join_slug_config.scope.
        where{number.in [my{number_from_slug(slug)}, my{slug}]}.first
      
      joins = joins_from_slug(slug)
      
      assoc = {}
      joins.each do |j|
        assoc["#{j}_id"] = slugs[j].to_s
      end

      scope.(assoc)
        

    end

  end

  module InstanceMethods
    def slug
      Slug.new(self).to_s
    end
  end

end
