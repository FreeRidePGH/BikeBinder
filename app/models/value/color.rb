module Value
  module Color
    
    def color
      ColorNameI18n::Color.new(super)
    end
    
  end
end
