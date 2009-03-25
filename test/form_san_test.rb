require File.expand_path('../helper', __FILE__)

require 'models/book'

class FormSanTest < ActiveSupport::TestCase
  test "should not forward methods to the helpers if they're private" do
    assert_raises(NoMethodError) do
      FormSan.hash_to_attributes
    end
    
    assert_raises(NoMethodError) do
      FormSan.default_url_options
    end
  end
  
  test "form_for constructs a form tag" do
    form = ''; FormSan.form_for(form, Book.new) {}
    assert_equal '<form method="post" action="/books"></form>', form
  end
  
  test "form_for yields a form builder" do
    form = ''; builder = nil
    FormSan.form_for(form, Book.new) { |f| builder = f }
    assert builder.kind_of?(FormSan::FormBuilder)
  end
  
  test "form_for generates a hidden div with an authenticity token" do
    form = ''; FormSan.form_for(form, Book.new, :authenticity_token => '8KpxINP') {}
    '<form action="/books" method="post"><div style="margin:0;padding:0"><input type="hidden" value="8KpxINP" name="authenticity_token" /></div></form>'
  end
  
  test "converts a hash to HTML tag attributes" do
    assert_equal '', FormSan.helpers.send(:hash_to_attributes, {})
    assert_equal ' id="mine"', FormSan.helpers.send(:hash_to_attributes, {:id => 'mine'})
    assert_equal ' style="width: 10px;" id="mine"', FormSan.helpers.send(:hash_to_attributes, {:id => 'mine', :style => 'width: 10px;'})
    assert_equal ' class="current active"', FormSan.helpers.send(:hash_to_attributes, {:class => ['current', 'active']})
    assert_equal ' class="current active"', FormSan.helpers.send(:hash_to_attributes, {'class' => [:current, :active]})
  end
  
  test "constructs an HTML tag" do
    output_buffer = ''; FormSan.tag(output_buffer, 'input')
    assert_equal '<input />', output_buffer
    output_buffer = ''; FormSan.tag(output_buffer, 'input', :type => 'text')
    assert_equal '<input type="text" />', output_buffer
  end
  
  test "constructs an HTML tag with content" do
    output_buffer = ''; FormSan.content_tag(output_buffer, 'div')
    assert_equal '<div></div>', output_buffer
    output_buffer = ''; FormSan.content_tag(output_buffer, :div)
    assert_equal '<div></div>', output_buffer
    
    output_buffer = ''; FormSan.content_tag(output_buffer, :div, :class => nil)
    assert_equal '<div></div>', output_buffer
    output_buffer = ''; FormSan.content_tag(output_buffer, :div, :class => 'current')
    assert_equal '<div class="current"></div>', output_buffer
    output_buffer = ''; FormSan.content_tag(output_buffer, :div, :class => %w(current active))
    assert_equal '<div class="current active"></div>', output_buffer
  end
  
  test "constructs HTML for an authenticity token" do
    output_buffer = ''; FormSan.authenticity_token(output_buffer, {})
    assert_equal '', output_buffer
    
    output_buffer = ''; FormSan.authenticity_token(output_buffer, { :authenticity_token => '8KpxINP'})
    assert_equal '<div style="margin:0;padding:0"><input type="hidden" value="8KpxINP" name="authenticity_token" /></div>', output_buffer
  end
end