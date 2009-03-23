TEST_ROOT_DIR = File.expand_path(File.dirname(__FILE__))
require 'test/unit'

frameworks = %w(activesupport)

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

ENV['RAILS_ENV'] = 'test'

# Rails libs
begin
  require 'active_support'
  require 'active_support/test_case'
rescue LoadError
  raise "Please install Form-San as Rails plugin before running the tests."
end

require File.expand_path('../../rails/init', __FILE__)

# Libraries for testing
require 'rubygems' rescue LoadError
require 'mocha'