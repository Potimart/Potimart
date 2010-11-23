unless defined?(RAILS_ENV)
  RAILS_ENV='test'

  require 'rubygems'

  # For details about this (complexe) loading, see ticket #359

  #
  # Setup ActiveRecord logger
  # 

  require 'logger'
  require 'active_record'

  log_file = File.join(File.dirname(__FILE__),"..","log","test.log")
  ActiveRecord::Base.logger = Logger.new(log_file)

  require 'spec'
  require 'factory_girl'

  #
  # Load chouette
  #

  lib_path = File.join(File.dirname(__FILE__),"..","lib")
  $:.unshift lib_path unless $:.include?(lib_path)

  require 'ruby_chouette'
  require 'chouette/geocoder'

  class ActiveRecord::Base
    @@chouette_connection = ChouetteActiveRecord.connection
    def self.connection
      @@chouette_connection
    end
  end

  # Make transactionnal model specs
  require 'database_cleaner'

  Spec::Runner.configure do |config|

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

  class ActiveRecord::Base
    
    def error_on(attribute)
      unless valid?
        Array(errors.on(attribute))
      else
        []
      end
    end

  end

end
