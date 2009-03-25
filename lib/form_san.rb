require 'form_san/form_builder'

module FormSan
  class Helpers
    include ActionController::UrlWriter
    include ActionController::RecordIdentifier
    include ActionController::PolymorphicRoutes
    
    protected :default_url_options, :default_url_options=
    
    def form_for(output_buffer, record, options={}, &block)
      options[:method] ||= record.new_record? ? 'post' : 'put'
      method = (options[:method].to_s == 'get') ? 'get' : 'post'
      content_tag(output_buffer, 'form', :action => polymorphic_path(record), :method => method) do
        extra_html = ''
        
        method_hack(extra_html, options)
        authenticity_token(extra_html, options)
        
        invisible(output_buffer) do
          output_buffer << extra_html
        end unless extra_html.blank?
        
        block.call(FormSan::FormBuilder.new(output_buffer, record, options)) if block_given?
      end
    end
    
    def content_tag(output_buffer, name, html_options={}, &block)
      output_buffer << "<#{name}#{hash_to_attributes(html_options)}>"
      block.call if block_given?
      output_buffer << "</#{name}>"
    end
    
    def tag(output_buffer, name, html_options={})
      output_buffer << "<#{name}#{hash_to_attributes(html_options)} />"
    end
    
    def invisible(output_buffer, &block)
      content_tag(output_buffer, 'div', :style => 'margin:0;padding:0') do
        block.call
      end
    end
    
    def method_hack(output_buffer, options)
      if options[:method] and !%w(get post).include?(options[:method].to_s)
        tag(output_buffer, 'input', :type => 'hidden', :name => '_method', :value => options[:method]) 
      end
    end
    
    def authenticity_token(output_buffer, options={})
      if options[:authenticity_token]
        tag(output_buffer, 'input', :type => 'hidden', :name => 'authenticity_token', :value => options[:authenticity_token]) 
      end
    end
    
    private
    
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
    if helpers.public_methods(inherited=false).include?(method.to_s)
      helpers.send(method, *arguments, &block)
    else
      super
    end
  end
end