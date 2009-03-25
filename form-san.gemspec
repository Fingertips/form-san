# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{form-san}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Manfred Stienstra"]
  s.date = %q{2009-03-25}
  s.description = %q{A form builder for ActionView.}
  s.email = %q{manfred@fngtps.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["lib/form_san.rb", "rails/init.rb", "README.rdoc", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/Fingertips/form-san}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Form-San is a form builder that makes it slightly easier to create fields with labels and validation messages.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
