require 'form_san/form_builder'

module FormSan
  def self.form_for(record, options={}, &block)
    content_tag('form') do
      block.call(FormSan::FormBuilder.new(record, self, options))
    end
  end
  
  def self.content_tag(name, html_options={}, &block)
    output = "<#{name}#{hash_to_attributes(html_options)}>"
    output << block.call if block_given?
    output << "</#{name}>"
  end
  
  def self.hash_to_attributes(html_options)
    attributes = html_options.map do |key, value|
      value = value.join(' ') if value.is_a?(Array)
      "#{key}=\"#{value}\"" if value
    end.compact
    attributes.empty? ? '' : " #{attributes.join(' ')}"
  end
end

