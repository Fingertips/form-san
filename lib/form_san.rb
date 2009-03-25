require 'action_view/helpers'

module FormSan
  class FormBuilder < ActionView::Helpers::FormBuilder
    def fieldset(&block)
      @template.content_tag('div', :class => 'fieldset', &block)
    end
    
    def fields(&block)
      @template.content_tag('div', :class => 'fields', &block)
    end
  end
end
