module FormSan
  class FormBuilder
    attr_accessor :output_buffer
    
    def initialize(output_buffer, record, options={})
      @output_buffer = output_buffer
      @record = record
      @options = options
    end
    
    def fieldset(&block)
      FormSan.content_tag(output_buffer, 'div', :class => 'fieldset') { block.call(self) }
    end
    
    def fields(&block)
      FormSan.content_tag(output_buffer, 'div', :class => 'fields') { block.call(self) }
    end
    
    def field(&block)
      FormSan.content_tag(output_buffer, 'div', :class => 'field') { block.call(self) }
    end
    
    def label(attribute, humanized_attribute=nil, html_options={}, &block)
      humanized_attribute ||= attribute.to_s.humanize
      if block_given?
        FormSan.content_tag(output_buffer, 'label', html_options) do
          block.call(self)
          output_buffer << " #{humanized_attribute}"
        end
      else
        html_options[:for] ||= "#{@record.class.name.downcase}_#{attribute}"
        FormSan.content_tag(output_buffer, 'div', :class => 'label') do
          FormSan.content_tag(output_buffer, 'label', html_options) do
            output_buffer << humanized_attribute
          end
        end
      end
    end
    
    def input(attribute, html_options={})
      html_options.reverse_merge!(
        :id   => "#{@record.class.name.downcase}_#{attribute}",
        :name => "#{@record.class.name.downcase}[#{attribute}]"
      )
      FormSan.tag(output_buffer, 'input', html_options)
    end
    
    def text_field(attribute, html_options={})
      input(attribute, html_options.reverse_merge(:type => 'text'))
    end
    
    def password_field(attribute, html_options={})
      input(attribute, html_options.reverse_merge(:type => 'password'))
    end
  end
end