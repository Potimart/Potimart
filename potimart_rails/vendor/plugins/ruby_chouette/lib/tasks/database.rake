# -*- coding: utf-8 -*-
namespace :db do
  namespace :chouette do
    root_path = File.dirname(File.dirname(File.dirname(__FILE__)))
    
    task :load_model do
      require File.join(root_path,"lib","ruby_chouette")
    end
    
    task :environment => [:load_rails, :load_model] do
      if Chouette.enabled?
        ActiveRecord::Base.establish_connection(ChouetteActiveRecord.configurations[Chouette.env])
        ActiveRecord::Base.logger ||= Logger.new('log/database.log')
      end
    end

    task :load_rails do
      begin
        rails_environment = Rake::Task["environment"] 
      rescue RuntimeError => e
        # task doesn't exist 
      end
      
      rails_environment.invoke if rails_environment
    end

    desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
    task :migrate => :environment do
      if Chouette.enabled?
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(File.join(root_path, "db","migrate"), ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
      end
    end

    desc "Creates the table cities from the data in vendor/insee.ville.csv"
    task :cities => :environment do
      if ChouetteActiveRecord.connected?
        City.load(File.join(root_path,"insee", "ville.csv"))
      end
    end

    desc "Generate temporary/false dates for Chouette database that only haves periods"
    task :dates => :environment do
      if ChouetteActiveRecord.connected?
        count = TimeTableDate.find(:first, :order => "DESC position").position || 1 rescue 1
        sql = ""
        (Time.now..1.month.since).step(1.day) do |time|
          sql << "INSERT INTO timetable_date SELECT tm.id,'#{time.strftime("%Y-%m-%d")}',#{count} FROM timetable tm;\n"
          count += 1
        end
        puts sql
        ChouetteActiveRecord.connection.execute(sql)
      end
    end

    desc "Mise à jour du fichier des communes"
    task :generate_ville_csv => :environment do

      File.open("ville.csv", 'w') do |f|
        f.write "\" Nom Ville \";\"MAJ   \";\" Code Postal \";\" Code INSEE \";\"Code Région\";\" Latitude \";\" Longitude \";\" Eloignement \"\n"
        City.all.sort_by{ |c| c.name}.each do |l|
          f.write "\"#{l.name}\";\"#{l.upcase_name}\";#{l.zip_code};#{l.insee_code};#{l.region_code};\"#{l.lat}\";\"#{l.lng}\";\"0\"\n"
        end
      end
    end

    desc "Denormalize Chouette database"
    task :denormalize => :environment do
      if ChouetteActiveRecord.connected?
        JourneyPatternStopPoint.load
        StopArea.denormalize_transport_mode
        puts "Dénormalisation terminée avec succès"
      end
    end

    desc "Denormalize Chouette database (for STIF only)"
    task :denormalize_stif => :environment do
      if ChouetteActiveRecord.connected?
        StopArea.denormalize_transport_mode
        puts "Dénormalisation terminée avec succès"
      end
    end

    desc "Update cities location in IDF (for STIF only)"
    task :update_cities_location_stif => :environment do
      if ChouetteActiveRecord.connected?
        City.update_locatisation [75, 92, 77, 78, 91, 92, 93, 94, 95]
        puts "Màj des localisation de 'cities' terminée avec succès"
      end
    end

    desc "Update places for cities in IDF (for STIF only)"
    task :load_city_places_stif => :environment do
      if ChouetteActiveRecord.connected?
        Place.load_city_places [75, 92, 77, 78, 91, 92, 93, 94, 95]
        puts "Création des leiux représentant les commune terminée avec succès"
      end
    end

    desc "Create Roads and RoadSections for Geocoder"
    task :roads => :environment do
      Chouette::Geocoder::Road.destroy_all
      Chouette::Geocoder::Road.create_all
    end

    desc "Create Locations and Zones for Geocoder"
    task :geocoder => :environment do
      Chouette::Geocoder::Location.destroy_all
      Chouette::Geocoder::Location.create_all
    end
    
  end
  
end
