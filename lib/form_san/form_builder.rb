module FormSan
  class FormBuilder
    attr_accessor :output
    alias to_s output
    
    def initialize(record, options={})
      @output = ''
      @record = record
      @options = options
    end
    
    def fields(html_options={}, &block)
      html_options[:class] ||= []
      html_options[:class] << 'fields'
      output << FormSan.content_tag('div', html_options) do
        block.call(self) if block_given?
      end
    end
    
    def fieldset(html_options={}, &block)
      html_options[:class] ||= []
      html_options[:class] << 'fieldset'
      output << FormSan.content_tag('div', html_options) do
        block.call(self) if block_given?
      end
    end
  end
end