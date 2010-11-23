namespace :potimart do
  desc "Initialization of Potimart database"
  task :install_database => ["db:template:drop", "db:template:create", "db:drop", "db:create", "db:migrate"] do
    puts "Finish to install database"
  end

  desc "Initialization of Potimart data"
  task :install_data => [:environment, "chouette:denormalize", "import:all_geometry"] do
    puts "Finish to install data"
  end


  def current_release
    `git log -n 1 --pretty=oneline`
  end

  def file_date
    Time.now.strftime "%Y%m%d-%H%M"
  end

  desc "Create an archive of Potimart sources"
  task :dist do
    mkdir_p "dist"
    sh "git archive HEAD | gzip -c > dist/potimart-#{file_date}-#{current_release[0..10]}.tar.gz"
  end
end
