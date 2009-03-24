module FormSan
  class FormBuilder
    attr_accessor :output
    alias output to_s
    
    def initialize(record, options={})
      @output = ''
      @record = record
      @options = options
    end
  end
end