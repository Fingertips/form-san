require 'action_view/helpers'

module FormSan
  class FormBuilder < ActionView::Helpers::FormBuilder
    def fieldset(&block)
      @template.content_tag(:div, :class => 'fieldset', &block)
    end
    
    def fields(&block)
      @template.content_tag(:div, :class => 'fields', &block)
    end
    
    def error_messages
      unless @object.errors.count.zero?
        attributes_with_errors =  @object.errors.map { |attribute, _| attribute } - ['base']
        @template.content_tag(:p, :class => 'errors') do
          if attributes_with_errors.size > 1
            @template.concat "Sorry, there were problems with the #{attributes_with_errors.to_sentence}."
          elsif attributes_with_errors.size == 1
            @template.concat "Sorry, there was a problem with the #{attributes_with_errors.first}."
          else
            @template.concat "#{@object.class} #{@object.errors.on(:base)}."
          end
        end
      else
        ''
      end
    end
    
    def field(attribute, *args, &block)
      options = args.extract_options!
      classes = @object.errors.on(attribute) ? %w(field invalid) : %w(field)
      @template.content_tag(:div, :class => classes) do
        @template.concat(
          @template.content_tag(:div, :class => 'label') do
            @template.concat self.label(attribute, *args)
          end
        )
        @template.concat ActionView::Helpers::InstanceTag.new(@object_name,
          attribute, self, options.delete(:object)).to_input_field_tag(options.delete(:type), options)
      end
      # FormSan.content_tag(output_buffer, 'div', :class => classes) do
      #   label(attribute, options[:humanized])
      #   input(attribute, html_options.merge(:type => options[:type]))
      #   error_message(attribute)
      #   output_buffer << block.call if block_given?
      # end
    end
  end
end
