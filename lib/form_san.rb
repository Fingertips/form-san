require 'form_san/form_builder'

module FormSan
  def self.form_for(record, options={}, &block)
    content_tag('form') do
      block.call(FormSan::FormBuilder.new(record, self, options))
    end
  end
  
  def self.content_tag(name, &block)
    output = "<#{name}>"
    output << block.call if block_given?
    output << "</#{name}>"
  end
end

