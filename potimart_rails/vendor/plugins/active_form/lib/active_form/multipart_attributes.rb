module ActiveForm
  module MultipartAttributes

    def self.included(base) #:nodoc:
      base.cattr_accessor :default_timezone, :instance_writer => false
      base.default_timezone = :local
    end

    def assign_multiparameter_attributes(pairs)
      execute_callstack_for_multiparameter_attributes(extract_callstack_for_multiparameter_attributes(pairs))
    end

    def instantiate_time_object(name, values)
      if self.class.respond_to?(:create_time_zone_conversion_attribute?) and self.class.send(:create_time_zone_conversion_attribute?, name)
        Time.zone.local(*values)
      else
        Time.time_with_datetime_fallback(default_timezone, *values)
      end
    end

    def class_for_attribute(name)
      if name =~ /_at$/
        Time
      end
    end

    def execute_callstack_for_multiparameter_attributes(callstack)
      errors = []
      callstack.each do |name, values|
        klass = class_for_attribute(name)
        if values.empty?
          send(name + "=", nil)
        else
          begin
            value = if Time == klass
                      instantiate_time_object(name, values)
                    elsif Date == klass
                      begin
                        Date.new(*values)
                      rescue ArgumentError => ex # if Date.new raises an exception on an invalid date
                        instantiate_time_object(name, values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
                      end
                    else
                      klass.new(*values)
                    end

            send(name + "=", value)
          rescue => ex
            puts ex
            puts ex.backtrace.join("\n")
            errors << ActiveRecord::AttributeAssignmentError.new("error on assignment #{values.inspect} to #{name}", ex, name)
          end
        end
      end
      unless errors.empty?
        raise ActiveRecord::MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
      end
    end

    def extract_callstack_for_multiparameter_attributes(pairs)
      attributes = { }

      for pair in pairs
        multiparameter_name, value = pair
        attribute_name = multiparameter_name.split("(").first
        attributes[attribute_name] = [] unless attributes.include?(attribute_name)

        unless value.empty?
          attributes[attribute_name] <<
            [ find_parameter_position(multiparameter_name), type_cast_attribute_value(multiparameter_name, value) ]
        end
      end

      attributes.each { |name, values| attributes[name] = values.sort_by{ |v| v.first }.collect { |v| v.last } }
    end

    def find_parameter_position(multiparameter_name)
      multiparameter_name.scan(/\(([0-9]*).*\)/).first.first
    end

    def type_cast_attribute_value(multiparameter_name, value)
      multiparameter_name =~ /\([0-9]*([a-z])\)/ ? value.send("to_" + $1) : value
    end
  end
end
