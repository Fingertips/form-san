require File.expand_path('../helper', __FILE__)

class BooksController
  def url_for(options)
    '/books/all'
  end
end

class FormBuilderTest < ActionView::TestCase
  tests ActionView::Helpers::FormHelper
  
  cattr_accessor :protect_against_forgery
  attr_accessor :output_buffer
  
  def setup
    output_buffer = ''
    
    @controller = BooksController.new
    @book = Book.new
  end
  
  test "form_for still works" do
    form_for(:post, @post, :builder => FormSan::FormBuilder) do |f| end
    assert_generated '<form action="/books/all" method="post"></form>'
  end
  
  test "fieldset wraps a set of field groups" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f|
      concat f.fieldset {}
    end
    assert_generated_in_form '<div class="fieldset"></div>'
  end
  
  test "fields wraps a group of fields" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f|
      concat f.fields {}
    end
    assert_generated_in_form '<div class="fields"></div>'
  end
  
  test "error_messages shows nothing when there are no errors" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.error_messages end
    assert_generated_in_form ''
  end
  
  test "error_messages shows an error when there is an error on one field" do
    @book.errors.add(:title, "can't be blank")
    
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.error_messages end
    assert_generated_in_form '<p class="errors">Sorry, there was a problem with the title.</p>'
  end
  
  test "error_messages shows an error when there is an error on two fields" do
    @book.errors.add(:title, "can't be blank")
    @book.errors.add(:isbn, "can't be blank")
    
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.error_messages end
    assert_generated_in_form '<p class="errors">Sorry, there were problems with the isbn and title.</p>'
  end
  
  test "error_messages shows an error when there is an error on multiple fields" do
    @book.errors.add(:title, "can't be blank")
    @book.errors.add(:isbn, "can't be blank")
    @book.errors.add(:published, "should not be set")
    
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.error_messages end
    assert_generated_in_form '<p class="errors">Sorry, there were problems with the isbn, title, and published.</p>'
  end
  
  test "error_messages shows an error when there is only an error on base" do
    @book.errors.add(:base, "can't be about bunnies")
    
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.error_messages end
    assert_generated_in_form '<p class="errors">Book can\'t be about bunnies.</p>'
  end
  
  test "wrapped_label generates a label in a div" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.wrapped_label(:title) end
    assert_generated_in_form '<div class="label"><label for="book_title">Title</label></div>'
  end
  
  test "wrapped_label generates a label in a div marked as optional" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.wrapped_label(:title, :optional => true) end
    assert_generated_in_form '<div class="label"><label for="book_title">Title <span>(optional)</span></label></div>'
  end
  
  test "wrapped_label generates a label with extra content" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f|
      f.wrapped_label(:title) do
        concat content_tag(:span, '(en)')
      end
    end
    assert_generated_in_form '<div class="label"><label for="book_title">Title</label><span>(en)</span></div>'
  end
  
  test "field generates a text field with label" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :text) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="text" /></div>'
  end
  
  test "field generates a password field with label" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :password) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="password" /></div>'
  end
  
  test "field generates a textarea with label" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :textarea) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title</label></div><textarea cols="40" id="book_title" name="book[title]" rows="20"></textarea></div>'
  end
  
  test "field generates a text field with label with specified humanized name" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, 'Cover title', :type => :text) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Cover title</label></div><input id="book_title" name="book[title]" size="30" type="text" /></div>'
  end
  
  test "field generates a text field with label that is marked optional" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :text, :optional => true) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title <span>(optional)</span></label></div><input id="book_title" name="book[title]" size="30" type="text" /></div>'
  end
  
  test "field generates a text field with label and extra content" do
    form_for(@book, :builder => FormSan::FormBuilder) do |f|
      f.field(:title, :type => :text) do
        concat content_tag(:p, 'Titles are displayed on the book', :class => 'note')
      end
    end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="text" /><p class="note">Titles are displayed on the book</p></div>'
  end
  
  test "field adds validation error messages to its content" do
    @book.errors.add(:title, "can't be blank")
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :text) end
    assert_generated_in_form '<div class="invalid field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="text" /><p class="notice">Can\'t be blank</p></div>'
  end
  
  test "field adds validation error messages to its label div for textareas" do
    @book.errors.add(:title, "can't be blank")
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :textarea) end
    assert_generated_in_form '<div class="invalid field"><div class="label"><label for="book_title">Title</label><p class="notice">Can\'t be blank</p></div><textarea cols="40" id="book_title" name="book[title]" rows="20"></textarea></div>'
  end
  
  test "field add validation error messages before extra content" do
    @book.errors.add(:title, "can't be blank")
    form_for(@book, :builder => FormSan::FormBuilder) do |f|
      f.field(:title, :type => :text) do
        concat content_tag(:p, 'Titles are displayed on the book', :class => 'note')
      end
    end
    assert_generated_in_form '<div class="invalid field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="text" /><p class="notice">Can\'t be blank</p><p class="note">Titles are displayed on the book</p></div>'
  end
  
  test "field adds attribute values the input tag" do
    @book.title = 'Empire of the Sun'
    form_for(@book, :builder => FormSan::FormBuilder) do |f| concat f.field(:title, :type => :text) end
    assert_generated_in_form '<div class="field"><div class="label"><label for="book_title">Title</label></div><input id="book_title" name="book[title]" size="30" type="text" value="Empire of the Sun" /></div>'
  end
  
  private
  
  def assert_generated(expected)
    assert_equal expected, output_buffer
  end
  
  def assert_generated_in_form(expected)
    if match = /<form[^>]+>(.*)<\/form>/.match(output_buffer)
      assert_equal expected, match[1]
    else
      flunk "There is no form in the output: #{output_buffer.inspect}"
    end
  end
  
  def protect_against_forgery?
    protect_against_forgery
  end
end