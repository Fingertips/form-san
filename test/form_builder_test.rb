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

class FormBuilderErrorMessagesTest < ActiveSupport::TestCase
  def setup
    @book = Book.new
    @output_buffer = ''
    @builder = FormSan::FormBuilder.new(@output_buffer, @book)
  end
  
  test "constructs a blank string when there are no error messages" do
    @builder.error_messages
    assert_equal '', @output_buffer
  end
  
  test "constructs a special error message for just one error" do
    @book.errors.add(:title, "can't be blank")
    @builder.error_messages
    assert_equal 'Sorry, there was a problem with the title.', @output_buffer
  end
  
  test "constructs a special error message for two errors" do
    @book.errors.add(:title, "can't be blank")
    @book.errors.add(:isbn, "should be 13 characters long")
    @builder.error_messages
    assert_equal 'Sorry, there were problems with the isbn and title.', @output_buffer
  end
  
  test "constructs a special error message a lot of errors" do
    @book.errors.add(:title, "can't be blank")
    @book.errors.add(:isbn, "should be 13 characters long")
    @book.errors.add(:published, "is not possible right now")
    @builder.error_messages
    assert_equal 'Sorry, there were problems with the isbn, title, and published.', @output_buffer
  end
  
  test "constructs a proper error message with only errors on base" do
    @book.errors.add_to_base("can't be about bunnies")
    @builder.error_messages
    assert_equal "Book can't be about bunnies.", @output_buffer
  end
end