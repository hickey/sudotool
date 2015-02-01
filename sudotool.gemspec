# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "sudotool"
  gem.version       = '1.1.1'
  gem.platform      = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'
  gem.authors       = ["Gerard Hickey"]
  gem.email         = ["ghickey@ebay.com"]
  # gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{sudo automation tool}
  gem.homepage      = "https://github.scm.corp.ebay.com/ghickey/sudotool"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency  'log4r', '~> 1.1.10'
  gem.add_dependency  'rainbow'
  
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec', '~> 2.11.0'
  #gem.add_development_dependency 'timecop', '~> 0.4.6'
end

