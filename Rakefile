
task :environment, [:env] do |cmd, args|
  ENV["RACK_ENV"] = args[:env] if args[:env] 
  require File.expand_path('../config/boot', __FILE__)
end

task :for_test, [:env] do |cmd, args|
  Rake::Task[:environment].execute(:env=>"test")
end

namespace :sq do
  namespace :migrate do

    desc "Perform automigration (reset your db data)"
    task :auto, [:env] => :environment do
      ::Sequel.extension :migration
      ::Sequel::Migrator.run Sequel::Model.db, "db/migrate", :target => 0
      ::Sequel::Migrator.run Sequel::Model.db, "db/migrate"
      puts "<= sq:migrate:auto executed"
    end

    desc "Perform migration up/down to VERSION"
    task :to, [:version, :env] => :environment do |t, args|
      version = (args[:version] || ENV['VERSION']).to_s.strip
      ::Sequel.extension :migration
      raise "No VERSION was provided" if version.empty?
      ::Sequel::Migrator.apply(Sequel::Model.db, "db/migrate", version.to_i)
      puts "<= sq:migrate:to[#{version}] executed"
    end

    desc "Perform migration up to latest migration available"
    task :up, [:env] => :environment do
      ::Sequel.extension :migration
      ::Sequel::Migrator.run Sequel::Model.db, "db/migrate"
      puts "<= sq:migrate:up executed"
    end

    desc "Perform migration down (erase all data)"
    task :down, [:env] => :environment do
      ::Sequel.extension :migration
      ::Sequel::Migrator.run Sequel::Model.db, "db/migrate", :target => 0
      puts "<= sq:migrate:down executed"
    end
  end
end

task :spec => [:for_test, :environment] do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:specs) do |t|
    t.rspec_opts = %w(--format RspecJunitFormatter --out rspec.xml)
  end
  Rake::Task[:specs].execute
end
