module SampleFilter
  module ActionViewExtension
    TRANSLATE_PREFIX = 'sample_filter'

    def form_for_filter(filter_class, options = {}, &block)
      options[:as] ||= :sample_filter
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
            type = filter_params_set.type_of(field)
            buffer <<
              content_tag(:div, class: 'sample-filter__form-item') do
                content_tag(:div, form.label(field, sft(prefix, :fields, field)), class: 'sample-filter__form-label') +
                content_tag(:div, send("#{type}_tag", form, prefix, filter_params_set, field), class: 'sample-filter__form-input-wrap')
              end
          end
          buffer << capture(&block) if block_given? && options[:block].eql?(:after)
          buffer + action_buttons(prefix)
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
      text_field_tag("#{as}[#{field}][from]", from, class: 'datepicker_input active') +
      content_tag(:div, ' - ', class: 'sample-filter__date-divider') +
      text_field_tag("#{as}[#{field}][to]", to, class: 'datepicker_input')
    end

    def boolean_tag(form, prefix, filter_params_set, field)
      form.select field, [[sft(:lists, :all_item), ''], [sft(prefix, :boolean, :true), 't'], [sft(prefix, :boolean, :false), 'f']]
    end

    def list_tag(form, prefix, filter_params_set, field)
      values = filter_params_set.values_for(field)
      form.select field, [[sft(:lists, :all_item), '']].concat(values.to_a)
    end

    def sorting_tag(form, prefix, filter_params_set, field)
      values = filter_params_set.values_for(field)
      form.select(field, values.map{|v| [[sft(prefix, field, v, :asc), "#{v}_asc"], [sft(prefix, field, v, :desc), "#{v}_desc"]]}.flatten(1))
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
