module Value

  module Linear

    module ConvertMethods
      def self.get_linear_val(val, optns={})
        return nil if val.nil?
        units = Settings::LinearUnit.persistance.units
        target_units = optns[:units]
        target_units ||= units
        (Unit.new(val)*units).convert_to(target_units)
      end

      def self.val_to_persist(val)
        return nil if val.nil?
        Settings::LinearUnit.to_persistance_units(val).scalar.to_f
      end
    end

    module SeatTubeHeight
      def self.included(base)
        # base.send(:include, InstanceMethods)
      end
      def seat_tube_height
        begin
          @seat_tube_height ||  ConvertMethods::get_linear_val(super)
        rescue
          super
        end
      end
      def seat_tube_height=(height)
        begin
          super(ConvertMethods::val_to_persist(height))
        rescue
          # Allow ill-formed values to be assigned so that they persist for validation
          # purposes in the model
          @seat_tube_height = height
        end
      end
    end

    module TopTubeLength
      def self.included(base)
        # base.send(:include, InstanceMethods)
      end
      def top_tube_length
        begin
          @top_tube_length || ConvertMethods::get_linear_val(super)
        rescue
          super
        end
      end
      def top_tube_length=(length)
        begin
          super(ConvertMethods::val_to_persist(length))
        rescue
          @top_tube_length = length
        end
      end
    end

  end

end
