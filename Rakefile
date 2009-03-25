require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

namespace :docs do
  Rake::RDocTask.new(:generate) do |rdoc|
    rdoc.main = "README"
    rdoc.title = 'Form-San'
    rdoc.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
    rdoc.options << "--all" << "--charset" << "utf-8"
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "form-san"
    
    s.email = "manfred@fngtps.com"
    s.homepage = "http://github.com/Fingertips/form-san"
    s.description = "A form builder for ActionView."
    s.summary =  "Form-San is a form builder that makes it slightly easier to create fields with labels and validation messages."
    s.authors = ["Manfred Stienstra"]
    s.files = %w(lib/form_san.rb rails/init.rb)
  end
end