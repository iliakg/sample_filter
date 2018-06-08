module SampleFilter
  class ParamsSet
    FILTER_TYPES = [:string, :number, :date, :boolean, :list, :sorting]

    attr_reader :options, :fields

    def initialize(options)
      @options = options.deep_symbolize_keys
      @fields = @options.keys

      define_and_assign_attr_accessors
    end

    def type_of(field)
      options[field.to_sym][:type].try(:to_sym)
    end

    def values_for(field)
      values = options[field.to_sym][:values]
      return unless values.present?

      if values.is_a?(Hash)
        values.stringify_keys
      elsif values.is_a?(Array)
        values.map(&:to_s)
      end
    end

    def update_value(field, values)
      field = field.to_sym
      raise(ArgumentError, "#{field} not found error") unless fields.include?(field)
      raise(ArgumentError, "#{field} values error") if invalid_values?(field, values)

      options[field][:values] = values
    end

    def permit_params(params)
      return {} unless params.present?
      _fields = fields.map{ |f| type_of(f).eql?(:date) ? Hash[f, [:from, :to]] : f }
      params.permit(_fields).to_hash.deep_symbolize_keys
    end

    def default_values
      Hash[fields.map { |field| [field, default_value_for(field)] }].compact
    end

    def update_attributes(params)
      _params = permit_params(params)
      fields.each { |field| instance_variable_set("@#{field}", _params[field] || default_value_for(field)) }
    end

    private

    def define_and_assign_attr_accessors
      fields.each do |field|
        raise(ArgumentError, "#{field} type error") if invalid_type?(field)
        raise(ArgumentError, "#{field} values error") if invalid_values?(field, values_for(field))

        self.class.send(:attr_reader, field)
        instance_variable_set("@#{field}", default_value_for(field))
      end
    end

    def invalid_type?(field)
      !FILTER_TYPES.include?(type_of(field))
    end

    def invalid_values?(field, values)
      return false unless [:list, :sorting].include?(type_of(field))
      return true unless values.present?

      if type_of(field).eql?(:list)
        (!values.is_a?(Hash) && !values.is_a?(Array))
      elsif type_of(field).eql?(:sorting)
        (!values.is_a?(Array))
      end
    end

    def default_value_for(field)
      default_value = options[field.to_sym][:default_value]
      return if default_value.nil?

      case type_of(field)
      when :date
        default_value.deep_symbolize_keys
      when :boolean
        if [true, 'true', 't'].include?(default_value)
          't'
        elsif [false, 'false', 'f'].include?(default_value)
          'f'
        end
      else
        default_value.to_s
      end
    end
  end
end
