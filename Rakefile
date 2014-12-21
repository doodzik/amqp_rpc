require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'reek/rake/task'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end
Reek::Rake::Task.new(:reek)

task default: [:spec, :rubocop, :reek]
