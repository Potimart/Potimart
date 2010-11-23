desc "Task for Cruise Control"
task :cruise => [ 'cruise:database_config', 'agilis:db:chouette:migrate', 'spec' ]

namespace :cruise do
  task :database_config do
    unless File.exists?("database_chouette.yml")
      cp "database_chouette.yml.sample", "database_chouette.yml"
    end
  end
end
