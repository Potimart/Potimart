namespace :import do
  desc "Import all data into the database."
  task :all_geometry => [:stoparea_geometry, :service_link] do
    puts "Finish to import all data"
  end

  desc "Import all iris geometry into the database."
  task :iris_geometry => :environment do
    InseeIris.destroy_all
    InseeIris.create_all("db/insee_iris.csv")
    #InseeIris.load_population("db/population/pop_91.csv")
    #InseeIris.load_population("db/population/pop_92.csv")
    #InseeIris.load_population("db/population/pop_94.csv")
    puts "Finish to import iris geometry into the database"
  end

  desc "Import all communes geometry into the database."
  task :communes_geometry => :environment do
    InseeCommune.destroy_all
    InseeCommune.create_all("db/insee_communes.csv")
    puts "Finish to import communes geometry into the database"
  end

  desc "Import all stoparea geometry into the database."
  task :stoparea_geometry => :environment do
    StopAreaGeo.destroy_all
    StopAreaGeo.create_all
    puts "Finish to import stoparea geometry into the database"
  end

  desc "Import service link geometry into the database."
  task :service_link => :environment do
    ServiceLink.destroy_all
    ServiceLink.create_all
    puts "Finish to import service link geometry into the database"
  end
end
