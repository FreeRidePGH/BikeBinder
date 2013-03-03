module Value

  module Linear
    module InstanceMethods
      def get_linear_val(val, optns={})
        units = Settings::LinearUnit.persistance.units
        target_units = optns[:units]
        target_units ||= units
        (Unit.new(val)*units).convert_to(target_units)
      end

      def val_to_persist(val)
        Settings::LinearUnit.to_persistance_units(val).scalar.to_f
      end
    end

    module SeatTubeHeight
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
      def seat_tube_height
        get_linear_val(super)
      end
      def seat_tube_height=(height)
        super(val_to_persist(height))
      end
    end

    module TopTubeLength
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
      def top_tube_length
        get_linear_val(super)
      end
      def top_tube_length=(length)
        super(val_to_persist(length))
      end
    end

  end

end
