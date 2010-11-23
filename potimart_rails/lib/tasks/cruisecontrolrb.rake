desc "Task for Cruise Control"
task :cruise => [ 'cruise:database_config', 'db:migrate', 'spec' ]

namespace :cruise do
  task :database_config do
    %w{database.yml database_chouette.yml}.each do |file|
      cp "config/#{file}.ccontrol", "config/#{file}"
    end
  end
end
