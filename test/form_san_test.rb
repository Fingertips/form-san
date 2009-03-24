require File.expand_path('../helper', __FILE__)

require 'models/book'

class FormSanTest < ActiveSupport::TestCase
  test "form_for should yield a form builder" do
    form = FormSan.form_for(Book.new) {}
    assert_equal '<form action="/books"></form>', form
  end
  
  test "converts a hash to HTML tag attributes" do
    assert_equal '', FormSan.hash_to_attributes({})
    assert_equal ' id="mine"', FormSan.hash_to_attributes({:id => 'mine'})
    assert_equal ' style="width: 10px;" id="mine"', FormSan.hash_to_attributes({:id => 'mine', :style => 'width: 10px;'})
    assert_equal ' class="current active"', FormSan.hash_to_attributes({:class => ['current', 'active']})
    assert_equal ' class="current active"', FormSan.hash_to_attributes({'class' => [:current, :active]})
  end
  
  test "constructs a HTML tag with content" do
    assert_equal '<div></div>', FormSan.content_tag('div')
    assert_equal '<div></div>', FormSan.content_tag(:div)
    
    assert_equal '<div></div>', FormSan.content_tag(:div, :class => nil)
    assert_equal '<div class="current"></div>', FormSan.content_tag(:div, :class => 'current')
    assert_equal '<div class="current active"></div>', FormSan.content_tag(:div, :class => %w(current active))
  end
end