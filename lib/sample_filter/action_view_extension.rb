module SampleFilter
  module ActionViewExtension
    FORM_DEFAULT_AS = :sample_filter
    TRANSLATE_PREFIX = 'sample_filter'

    def form_for_filter(filter_class, options = {}, &block)
      options[:as] ||= FORM_DEFAULT_AS
      options[:block] ||= :after
      options[:html] ||= {}
      options[:html][:method] ||= :get
      options[:html][:id] ||= :sample_filter
      options[:url] ||= url_for(
        :controller => controller.controller_name,
        :action => controller.action_name
      )

      filter_params_set = filter_class.filter_params_set
      filter_params_set.update_attributes(params[options[:as]])

      prefix = filter_class.to_s.underscore
      content_tag :div, id: 'sample-filter__wrap' do
        form_for(filter_params_set, options) do |form|
          buffer = ActiveSupport::SafeBuffer.new
          buffer << capture(&block) if block_given? && options[:block].eql?(:before)
          filter_params_set.fields.each do |field|
            buffer <<
              if filter_params_set.hidden_input?(field)
                form.hidden_field field
              else
                type = filter_params_set.type_of(field)
                content_tag(:div, class: "sample-filter__form-item #{field}") do
                  content_tag(:div, form.label(field, sft(prefix, :fields, field)), class: 'sample-filter__form-label') +
                  content_tag(:div, send("#{type}_tag", form, prefix, filter_params_set, field), class: 'sample-filter__form-input-wrap')
                end
              end
          end
          buffer << capture(&block) if block_given? && options[:block].eql?(:after)
          buffer + action_buttons(prefix)
        end
      end
    end

    def sort_link(filter_class, sorting_field, form_as = FORM_DEFAULT_AS)
      sorting_field = sorting_field.to_s
      filter_params_set = filter_class.filter_params_set
      sorting_key = filter_params_set.sorting_key
      values = filter_params_set.values_for(sorting_key)
      return unless values.include?(sorting_field)

      default_value = filter_params_set.default_value_for(sorting_key)
      query_param = params[form_as]
      if query_param && query_param[sorting_key]
        query_param_sort_key = query_param[sorting_key][/\A(.*)_(asc|desc)\z/, 1]
        param_set = params.require(form_as).permit!
        if query_param_sort_key == sorting_field
          sort_direction = query_param[sorting_key][/\A(.*)_(asc|desc)\z/, 2]
          if sort_direction == 'asc'
            link_to('', url_for(form_as => param_set.merge({sorting_key => "#{sorting_field}_desc"})), class: 'sample_filter__sort_link asc')
          else
            link_to('', url_for(form_as => param_set.merge({sorting_key => "#{sorting_field}_asc"})), class: 'sample_filter__sort_link desc')
          end
        else
          link_to('', url_for(form_as => param_set.merge({sorting_key => "#{sorting_field}_desc"})), class: 'sample_filter__sort_link neutral')
        end
      else
        default_field = default_value[/\A(.*)_(asc|desc)\z/, 1] if default_value
        if sorting_field == default_field
          sort_direction = default_value[/\A(.*)_(asc|desc)\z/, 2]
          if sort_direction == 'asc'
            link_to('', url_for(form_as => {sorting_key => "#{sorting_field}_desc"}), class: 'sample_filter__sort_link asc')
          else
            link_to('', url_for(form_as => {sorting_key => "#{sorting_field}_asc"}), class: 'sample_filter__sort_link desc')
          end
        else
          link_to('', url_for(form_as => {sorting_key => "#{sorting_field}_desc"}), class: 'sample_filter__sort_link neutral')
        end
      end
    end

    private

    def string_tag(form, prefix, filter_params_set, field)
      form.text_field field
    end

    def number_tag(form, prefix, filter_params_set, field)
      form.number_field field
    end

    def date_tag(form, prefix, filter_params_set, field)
      as = form.options[:as]
      from = filter_params_set.send(field).try(:[], :from)
      to = filter_params_set.send(field).try(:[], :to)
      text_field_tag("#{as}[#{field}][from]", from, class: 'datepicker_input active', autocomplete: 'off') +
      content_tag(:div, ' - ', class: 'sample-filter__date-divider') +
      text_field_tag("#{as}[#{field}][to]", to, class: 'datepicker_input', autocomplete: 'off')
    end

    def boolean_tag(form, prefix, filter_params_set, field)
      form.select field, [[sft(prefix, :list, field, :all_item), ''], [sft(prefix, :list, field, :true), 't'], [sft(prefix, :list, field, :false), 'f']]
    end

    def list_tag(form, prefix, filter_params_set, field)
      values = filter_params_set.values_for(field)

      translated_values =
        if values.is_a?(Hash)
          values.map{|el| [sft(prefix, :list, field, el[0]), el[1]]}
        elsif values.is_a?(Array)
          values.map{|el| [sft(prefix, :list, field, el), el]}
        end

      form.select field, [[sft(prefix, :list, field, :all_item), '']].concat(translated_values)
    end

    def sorting_tag(form, prefix, filter_params_set, field)
      values = filter_params_set.values_for(field)
      form.select(field, values.map{|v| [[sft(prefix, :list, field, v, :asc), "#{v}_asc"], [sft(prefix, :list, field, v, :desc), "#{v}_desc"]]}.flatten(1))
    end

    def action_buttons(prefix)
      content_tag(:div, class: 'sample-filter__form-item form-actions') do
        submit_tag(sft(prefix, :buttons, :submit)) +
        button_tag(sft(prefix, :buttons, :clear_form), class: 'sample-filter__clear-form')
      end
    end

    def sft(*keys)
      I18n.t(keys.unshift(TRANSLATE_PREFIX).join('.'))
    end
  end
end
