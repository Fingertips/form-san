module FormSan
  class FormBuilder
    attr_accessor :output_buffer
    
    def initialize(output_buffer, record, options={})
      @output_buffer = output_buffer
      @record = record
      @options = options
    end
    
    def error_messages(html_options={})
      unless @record.errors.count.zero?
        FormSan.content_tag(output_buffer, 'p', html_options.reverse_merge(:class => 'errors')) do
          attributes_with_errors =  @record.errors.map { |attribute, _| attribute } - ['base']
          if attributes_with_errors.size > 1
            output_buffer << "Sorry, there were problems with the #{attributes_with_errors.to_sentence}."
          elsif attributes_with_errors.size == 1
            output_buffer << "Sorry, there was a problem with the #{attributes_with_errors.first}."
          else
            output_buffer << "#{@record.class} #{@record.errors.on(:base)}."
          end
        end
      end
    end
    
    def error_message(attribute, html_options={})
      unless @record.errors.on(attribute).blank?
        FormSan.content_tag(output_buffer, 'p', html_options.reverse_merge(:class => 'notice')) do
          output_buffer << @record.errors.on(attribute).mb_chars.capitalize
        end
      end
    end
    
    def fieldset(&block)
      FormSan.content_tag(output_buffer, 'div', :class => 'fieldset') { block.call(self) }
    end
    
    def fields(&block)
      FormSan.content_tag(output_buffer, 'div', :class => 'fields') { block.call(self) }
    end
    
    def field(attribute, options={}, html_options={}, &block)
      classes = %w(field)
      classes << 'invalid' if @record.errors.on(attribute)
      html_options.reverse_merge!(:value => self.class.value_before_type_cast(@record, attribute))
      FormSan.content_tag(output_buffer, 'div', :class => classes) do
        label(attribute, options[:humanized])
        input(attribute, html_options.merge(:type => options[:type]))
        error_message(attribute)
        output_buffer << block.call if block_given?
      end
    end
    
    def label(attribute, humanized_attribute=nil, html_options={}, &block)
      humanized_attribute ||= @record.class.human_attribute_name(attribute.to_s)
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
    
    def submit(label, html_options={})
      html_options.reverse_merge!(
        :value => label,
        :type => 'submit'
      )
      FormSan.tag(output_buffer, 'input', html_options)
    end
    
    def self.value_before_type_cast(object, attribute)
      if object.respond_to?("#{attribute}_before_type_cast")
        object.send("#{attribute}_before_type_cast")
      else
        object.send(attribute)
      end
    rescue NoMethodError
    end
  end
end