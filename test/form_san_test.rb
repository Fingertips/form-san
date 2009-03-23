require File.expand_path('../helper', __FILE__)

class FormSanTest < ActiveSupport::TestCase
  test "constructs a HTML tag with content" do
    assert_equal '<div></div>', FormSan.content_tag('div')
  end
end