require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = "spec"
    t.rspec_opts = "--format progress"
  end
rescue LoadError
  task :spec do
    puts "RSpec not installed"
    exit 1
  end
end

task :default => %w(spec)
