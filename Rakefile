# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "statsample-glm"
  gem.homepage = "http://github.com/AnkurGel/statsample-glm"
  gem.license = "MIT"
  gem.summary = %Q{Generalized Linear Models for Statsample}
  gem.description = %Q{Statsample-GLM is an extension to Statsample, an advance statistics suite in Ruby. This gem includes modules for Regression techniques such as Poisson Regression, Logistic Regression and Exponential Regression}
  gem.email = "ankurgel@gmail.com"
  gem.authors = ["Ankur Goel"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "statsample-glm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
