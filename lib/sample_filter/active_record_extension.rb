require 'sample_filter/params_set'

module SampleFilter
  module ActiveRecordExtension

    def sample_filter(options)
      class << self
        attr_accessor :filter_params_set
      end

      self.filter_params_set = SampleFilter::ParamsSet.new(options)
    end


    def filtered(params)
      ar_rel = all
      _params = params.present? ? filter_params_set.permit_params(params) : filter_params_set.default_values

      _params.each do |param|
        field = param.first
        value = param.last
        ar_rel = send("#{filter_params_set.type_of(field)}_query", ar_rel, field, value) if value.present?
      end
      ar_rel
    end

    private

    def string_query(ar_rel, field, value)
      ar_rel.where("#{field} ILIKE ?", "%#{value}%")
    end

    def number_query(ar_rel, field, value)
      ar_rel.where("#{field} = ?", value)
    end

    def date_query(ar_rel, field, value)
      ar_rel = ar_rel.where("#{field} >= ?", Time.zone.parse(value[:from])) if value[:from].present?
      ar_rel = ar_rel.where("#{field} <= ?", Time.zone.parse(value[:to])) if value[:to].present?
      ar_rel
    end

    def boolean_query(ar_rel, field, value)
      ar_rel.where("#{field} = ?", value)
    end

    def list_query(ar_rel, field, value)
      ar_rel.where("#{field} = ?", value)
    end

    def sorting_query(ar_rel, field, value)
      values = value.scan(/(.*)_(desc|asc)/).flatten
      column = values.first
      return ar_rel unless filter_params_set.values_for(field).include?(column)
      direction = values.last.downcase == 'asc' ? 'asc' : 'desc'

      ar_rel.order("#{column} #{direction}")
    end
  end
end
