module Settings
  class LinearUnit
    
    def self.options
      ['inch', 'cm']
    end
    
    def self.persistance
      Unit.new('mm')
    end

    def self.to_persistance_units(q)
      return nil if q.nil?

      units = self.persistance.units
      val = (q.respond_to?(:units)) ?
      q.convert_to(units) : Unit.new(q) * units
    end
    
    def self.default_display
      Unit.new('inch')
    end
    
    def self.default_input
      Unit.new('inch')
    end
    
    def display
      self.class.default_display
    end
    
    def input
      self.class.default_input
    end
    
  end
  
  class Color
    def self.options
      Select2BikeBinder.configuration.color_option_keys
    end

    def self.option_set
      self.options.map{|c| ColorNameI18n::Color.new(c)}
    end
  end

  class Date
    
    def initialize(date)
      @date = date
    end

    def default_s
      @date.in_time_zone(Time.zone).strftime(Date.default_format)
    end

    def long_s
      @date.in_time_zone(Time.zone).strftime(I18n.translate(:long, :scope => 'date.formats'))
    end
    
    def self.default_format
      I18n.translate(:default, :scope => 'date.formats')
    end
  end
end # module Settings
