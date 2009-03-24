module FormSan
  class FormBuilder
    attr_accessor :output_buffer
    
    def initialize(output_buffer, record, options={})
      @output_buffer = output_buffer
      @record = record
      @options = options
    end
    
    def fields(html_options={}, &block)
      html_options[:class] ||= []
      html_options[:class] << 'fields'
      FormSan.content_tag(output_buffer, 'div', html_options) do
        block.call(self) if block_given?
      end
    end
    
    def fieldset(html_options={}, &block)
      html_options[:class] ||= []
      html_options[:class] << 'fieldset'
      FormSan.content_tag(output_buffer, 'div', html_options) do
        block.call(self) if block_given?
      end
    end
  end
end