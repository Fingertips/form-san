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
  end
end
