require 'securerandom'
if RUBY_PLATFORM == 'opal'
  require 'native'
end

module Chosen
  class MainController < Volt::ModelController
    before_action :setup_field

    def setup_field
      unless attrs.value_last_method
        field_type = self.class.to_s.underscore.gsub(/[_]Controller$/, '')
        raise "a <:chosen tag was used without passing a value attribute"
      end

      # Get the name of the field by looking at the method scope
      @field_name = attrs.value_last_method.gsub(/^[_]/, '')
    end

    # Set the model to attrs.options so that we don't render the view until
    # the promise passed to attrs.options resolves.
    def index
      self.model = attrs.options
    end

    # Currently catches the 'change' event and re-raises it as chosen:changed due
    # to a framework conflict that was throwing an error.
    # See related issue:
    def index_ready
      options = attrs.chosen_options || {}
      options[:width] ||= "100%"
      `$(#{selector}).chosen(#{options.to_n}).change(function(e, params) {
        e.stopPropagation();
        $(".my_select_box").trigger('chosen:change', params);
      });`
    end

    def before_index_remove
      `$(#{selector}).chosen("destroy");`
    end

    def update_chosen
      `$(#{selector}).trigger('chosen:updated');`
      nil
    end

    def unique_klass
      @unique_klass ||= random_id
    end

    def selector
      ".#{@unique_klass}"
    end

    def random_id
      "xxxxx".gsub /[xy]/ do |ch,|
        %x{
          var r = Math.random() * 16 | 0,
              v = ch == "x" ? r : (r & 3 | 8);
          return v.toString(16);
        }
      end
    end

    # Find the parent reactive value that produced the value
    # (usually just model._field)
    def model_inst
      attrs.value_parent
    end

    def label
      unless ['false','False'].include?(attrs.label)
        attrs.label || @field_name.titleize
      end
    end

    # Find the errors for this field
    def errors
      model_inst.marked_errors[@field_name]
    end

    def field_name
      @field_name
    end

    # When a field goes out of focus, then we want to start checking a field
    def blur
      model_inst.mark_field!(@field_name)
    end

    def marked
      model_inst.marked_fields[@field_name]
    end

    def options
      attrs.options.then do |options|
        if options[0].is_a?(Hash)
          options_hash = options
        else
          options_hash = options.collect { |option| {value: option, label: option }}
        end
        options_hash
      end
    end

    def selected(value)
      if attrs.multiple == true || attrs.multiple == 'true'
        if attrs.value.include?(value)
          res = true
        else
          res = false
        end
      else
        if attrs.value == value
          res = true
        else
          res = false
        end
      end
      res
    end
  end
end
