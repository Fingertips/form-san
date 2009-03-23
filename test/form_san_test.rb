require File.expand_path('../helper', __FILE__)

class FormSanTest < ActiveSupport::TestCase
  test "constructs a HTML tag with content" do
    assert_equal '<div></div>', FormSan.content_tag('div')
    assert_equal '<div></div>', FormSan.content_tag(:div)
    
    assert_equal '<div></div>', FormSan.content_tag(:div, :class => nil)
    assert_equal '<div class="current"></div>', FormSan.content_tag(:div, :class => 'current')
    assert_equal '<div class="current active"></div>', FormSan.content_tag(:div, :class => %w(current active))
  end
end