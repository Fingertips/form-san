require File.expand_path('../helper', __FILE__)

require 'models/book'

class FormBuilderTest < ActiveSupport::TestCase
  def setup
    @output_buffer = ''
    @builder = FormSan::FormBuilder.new(@output_buffer, Book.new)
  end
  
  test "construct a fieldset" do
    @builder.fieldset
    assert_equal '<div class="fieldset"></div>', @output_buffer
  end
  
  test "construct a fieldset with contents" do
    @builder.fieldset { @output_buffer << 'content' }
    assert_equal '<div class="fieldset">content</div>', @output_buffer
  end
  
  test "construct a group of fields" do
    @builder.fields
    assert_equal '<div class="fields"></div>', @output_buffer
  end
  
  test "construct a group of fields with content" do
    @builder.fields { @output_buffer << 'content' }
    assert_equal '<div class="fields">content</div>', @output_buffer
  end
end