require File.expand_path('../helper', __FILE__)

require 'models/book'

class FormBuilderTest < ActiveSupport::TestCase
  def setup
    @builder = FormSan::FormBuilder.new(Book.new)
  end
  
  test "construct a fieldset" do
    @builder.fieldset
    assert_equal '<div class="fieldset"></div>', @builder.to_s
  end
  
  test "construct a fieldset with contents" do
    @builder.fieldset { 'content' }
    assert_equal '<div class="fieldset">content</div>', @builder.to_s
  end
  
  test "construct a group of fields" do
    @builder.fields
    assert_equal '<div class="fields"></div>', @builder.to_s
  end
  
  test "construct a group of fields with content" do
    @builder.fields { 'content' }
    assert_equal '<div class="fields">content</div>', @builder.to_s
  end
end