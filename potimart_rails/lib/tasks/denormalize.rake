namespace :chouette do
  desc "Denormalize Chouette database"
  task :denormalize => :environment do
    if ChouetteActiveRecord.connected?
      JourneyPatternStopPoint.load
      StopArea.denormalize_transport_mode
      puts "Dénormalisation terminée avec succès"
    end
  end
end