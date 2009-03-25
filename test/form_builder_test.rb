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