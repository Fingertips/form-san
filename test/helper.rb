TEST_ROOT_DIR = File.expand_path(File.dirname(__FILE__))
require 'test/unit'

frameworks = %w(activesupport activerecord actionpack)

rails = [
  File.expand_path('../../../rails', TEST_ROOT_DIR),
  File.expand_path('../../rails', TEST_ROOT_DIR)
].detect do |possible_rails|
  begin
    entries = Dir.entries(possible_rails)
    frameworks.all? { |framework| entries.include?(framework) }
  rescue Errno::ENOENT
    false
  end
end

frameworks.each { |framework| $:.unshift(File.join(rails, framework, 'lib')) }
$:.unshift File.join(TEST_ROOT_DIR, '/../lib')
$:.unshift File.join(TEST_ROOT_DIR, '/lib')
$:.unshift TEST_ROOT_DIR

ENV['RAILS_ENV'] = 'test'

# Rails libs
begin
  require 'action_controller'
  require 'action_controller/cgi_ext'
  require 'action_controller/test_process'
  require 'action_view/test_case'
rescue LoadError
  raise "Please install Form-San as Rails plugin before running the tests."
end

require File.expand_path('../../rails/init', __FILE__)

# Libraries for testing
require 'rubygems' rescue LoadError
require 'mocha'

# Load Routes
require 'routes'