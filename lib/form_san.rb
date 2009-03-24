require 'form_san/form_builder'

module FormSan
  class Helpers
    include ActionController::UrlWriter
    include ActionController::RecordIdentifier
    include ActionController::PolymorphicRoutes
    
    def form_for(record, options={}, &block)
      content_tag('form', :action => polymorphic_path(record)) do
        block.call(FormSan::FormBuilder.new(record, options))
      end
    end
    
    def content_tag(name, html_options={}, &block)
      output = "<#{name}#{hash_to_attributes(html_options)}>"
      output << block.call.to_s if block_given?
      output << "</#{name}>"
    end
    
    def hash_to_attributes(html_options)
      attributes = html_options.map do |key, value|
        value = value.join(' ') if value.is_a?(Array)
        "#{key}=\"#{value}\"" if value
      end.compact
      attributes.empty? ? '' : " #{attributes.join(' ')}"
    end
  end
  
  def self.helpers
    @helpers ||= FormSan::Helpers.new
  end
  
  def self.method_missing(method, *arguments, &block)
    helpers.send(method, *arguments, &block)
  end
end