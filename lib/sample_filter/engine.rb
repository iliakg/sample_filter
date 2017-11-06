require 'sample_filter/active_record_extension'
require 'sample_filter/action_view_extension'

module SampleFilter
  class Engine < ::Rails::Engine
    isolate_namespace SampleFilter

    ActiveSupport.on_load :active_record do
      extend SampleFilter::ActiveRecordExtension
    end

    ActiveSupport.on_load :action_view do
      include SampleFilter::ActionViewExtension
    end
  end
end
