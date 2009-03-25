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
    @book = stub(:title => 'Empire of the Sun')
  end
  
  test "form_for still works" do
    form_for(:post, @post, :builder => FormSan::FormBuilder) do |f| end
    assert_generated '<form action="/books/all" method="post"></form>'
  end
  
  test "fieldset wraps a set of field groups" do
    form_for(:post, @post, :builder => FormSan::FormBuilder) do |f|
      concat f.fieldset {}
    end
    assert_generated_in_form '<div class="fieldset"></div>'
  end
  
  test "fields wraps a group of fields" do
    form_for(:post, @post, :builder => FormSan::FormBuilder) do |f|
      concat f.fields {}
    end
    assert_generated_in_form '<div class="fields"></div>'
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