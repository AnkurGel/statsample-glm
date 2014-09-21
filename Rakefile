# encoding: utf-8
require 'rake'
require 'bundler/gem_tasks'

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

desc "Open IRB with statsample-timeseries loaded."
task :console do
  require 'irb'
  require 'irb/completion'
  $:.unshift File.expand_path("../lib", __FILE__)
  require 'statsample-glm'
  ARGV.clear
  IRB.start
end


require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  $:.unshift File.expand_path("../lib", __FILE__)
  version = Statsample::GLM::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "statsample-glm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
