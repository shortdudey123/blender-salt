require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'rubocop compliancy checks'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.patterns = %w(
    lib/**/*.rb
    lib/*.rb
    spec/*.rb
    spec/**/.rb
    Rakefile
    *.gemspec
  )
end

task default: [:rubocop, :spec]
