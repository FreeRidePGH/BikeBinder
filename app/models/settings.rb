module Settings
  class LinearUnit
    def self.persistance_unit
      'mm'
    end

    def self.default_display
      'inch'
    end

    def self.default_input
      'inch'
    end
  end

  class Color
    def self.options
      Select2BikeBinder.configuration.color_option_keys
    end
  end
end # module Settings



