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
  
  test "construct a label" do
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
  
  test "construct a text field" do
    @builder.text_field(:title)
    assert_equal '<input type="text" name="book[title]" id="book_title" />', @output_buffer
  end
  
  test "construct a text field with custom id" do
    @builder.text_field(:title, :id => 'custom')
    assert_equal '<input type="text" name="book[title]" id="custom" />', @output_buffer
  end
  
  test "construct a password field" do
    @builder.password_field(:password)
    assert_equal '<input type="password" name="book[password]" id="book_password" />', @output_buffer
  end
  
  test "construct a password field with custom id" do
    @builder.password_field(:password, :id => 'custom')
    assert_equal '<input type="password" name="book[password]" id="custom" />', @output_buffer
  end
  
  test "construct a submit button" do
    @builder.submit('Save')
    assert_equal '<input type="submit" value="Save" />', @output_buffer
  end
  
  test "construct a submit button with a name" do
    @builder.submit('Save', :name => 'continue')
    assert_equal '<input type="submit" value="Save" name="continue" />', @output_buffer
  end
end