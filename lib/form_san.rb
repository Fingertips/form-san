require 'action_view/helpers'

module FormSan
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template
    delegate :concat, :content_tag, :to => :template
    
    def fieldset(&block)
      content_tag(:div, :class => 'fieldset', &block)
    end
    
    def fields(&block)
      content_tag(:div, :class => 'fields', &block)
    end
    
    def error_messages
      unless @object.errors.count.zero?
        attributes_with_errors =  @object.errors.map { |attribute, _| attribute } - ['base']
        content_tag(:p, :class => 'errors') do
          if attributes_with_errors.size > 1
            concat "Sorry, there were problems with the #{attributes_with_errors.to_sentence}."
          elsif attributes_with_errors.size == 1
            concat "Sorry, there was a problem with the #{attributes_with_errors.first}."
          else
            concat "#{@object.class} #{@object.errors.on(:base)}."
          end
        end
      else
        ''
      end
    end
    
    def error_message(attribute)
      unless @object.errors.on(attribute).blank?
        content_tag(:p, :class => 'notice') do
          concat ERB::Util.html_escape(@object.errors.on(attribute).mb_chars.capitalize)
        end
      else
        ''
      end
    end
    
    def wrapped_label(attribute, *args)
      options = args.extract_options!
            
      label_text = args.first || attribute.to_s.humanize
      label_text << ' <span>(optional)</span>' if options[:optional]
      
      content_tag(:div, :class => 'label') do
        concat label(attribute, label_text)
      end
    end
    
    def field_with_extra_content(attribute, extra_content=nil, *args)
      options = args.extract_options!
      classes = @object.errors.on(attribute) ? 'invalid field' : 'field'
      
      content_tag(:div, :class => classes) do
        concat wrapped_label(attribute, args.first, :optional => options.delete(:optional))
        
        case input_type = options.delete(:type).to_s
        when 'textarea'
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_text_area_tag(options)
        else
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_input_field_tag(input_type, options)
        end
        
        concat error_message(attribute)
        concat extra_content unless extra_content.blank?
        @template.output_buffer # The block needs to return the current buffer
      end
    end
    
    def field(attribute, *args, &block)
      if block_given?
        concat field_with_extra_content(attribute, @template.capture(&block), *args)
      else
        field_with_extra_content(attribute, nil, *args)
      end
    end
  end
end

class ActionView::Helpers::InstanceTag
  def error_wrapping(html_tag, has_error)
    html_tag
  end
end