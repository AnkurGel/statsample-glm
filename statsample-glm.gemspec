# coding: utf-8
$:.unshift File.expand_path("../lib", __FILE__)

require 'statsample-glm/version'

DESCRIPTION = <<MSG
Statsample-GLM is an extension to Statsample, an advance statistics suite in
Ruby. This gem includes modules for Regression techniques such as Poisson 
and Logistic Regression using the IRLS algorithm and Logistic,  
Probit and Normal Regression using the Newton Raphson algorithm.
MSG

Gem::Specification.new do |spec|
  spec.name          = 'statsample-glm'
  spec.version       = Statsample::GLM::VERSION
  spec.authors       = ['Ankur Goel', 'Sameer Deshmukh']
  spec.email         = ['sameer.deshmukh93@gmail.com']
  spec.summary       = %q{Generalized Linear Models for Statsample}
  spec.description   = DESCRIPTION
  spec.homepage      = "http://github.com/sciruby/statsample-glm"
  spec.license       = 'BSD-2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'statsample', '~> 1.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rdoc', '~> 3.12'
end
