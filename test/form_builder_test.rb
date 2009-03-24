require File.expand_path('../helper', __FILE__)

require 'models/book'

class FormBuilderTest < ActiveSupport::TestCase
  def setup
    @output_buffer = ''
    @builder = FormSan::FormBuilder.new(@output_buffer, Book.new)
  end
  
  test "construct a fieldset with contents" do
    @builder.fieldset { @output_buffer << 'content' }
    assert_equal '<div class="fieldset">content</div>', @output_buffer
  end
  
  test "construct a group of fields with content" do
    @builder.fields { @output_buffer << 'content' }
    assert_equal '<div class="fields">content</div>', @output_buffer
  end
  
  test "construct a field with content" do
    @builder.field { @output_buffer << 'content' }
    assert_equal '<div class="field">content</div>', @output_buffer
  end
  
  test "construct a default label" do
    @builder.label :published
    assert_equal '<div class="label"><label for="book_published">Published</label></div>', @output_buffer
  end
  
  test "construct a label with humanized attribute" do
    @builder.label :published, 'Visible online'
    assert_equal '<div class="label"><label for="book_published">Visible online</label></div>', @output_buffer
  end
  
  test "construct a custom label with contents" do
    @builder.label(:published) do
      @output_buffer << '<input type="checkbox" name="make" value="money" />'
    end
    assert_equal '<label><input type="checkbox" name="make" value="money" /> Published</label>', @output_buffer
  end
  
  test "construct a custom label with contents and humanized attribute" do
    @builder.label(:published, 'Visible online') do
      @output_buffer << '<input type="checkbox" name="make" value="money" />'
    end
    assert_equal '<label><input type="checkbox" name="make" value="money" /> Visible online</label>', @output_buffer
  end
end