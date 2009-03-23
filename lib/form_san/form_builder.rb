module FormSan
  class FormBuilder
    attr_accessor :output
    
    def initialize(record, options={})
      @record = record
      @options = options
    end
  end
end