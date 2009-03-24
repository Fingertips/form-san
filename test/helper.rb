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
  require 'active_support'
  require 'active_support/test_case'
  require 'active_record'
  require 'action_controller'
rescue LoadError
  raise "Please install Form-San as Rails plugin before running the tests."
end

require File.expand_path('../../rails/init', __FILE__)

# Libraries for testing
require 'rubygems' rescue LoadError
require 'mocha'

# Establish connection with an in-memory Sqlite database
ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3', 'database' => ':memory:'})
require 'schema'

# Load Routes
require 'routes'