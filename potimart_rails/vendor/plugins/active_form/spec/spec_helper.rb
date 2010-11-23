base_app_root = 
  (ENV['RAILS_ROOT'] or File.join(File.dirname(__FILE__), %w{..} * 4))
base_app_spec_helper = File.expand_path(File.join(base_app_root, 'spec', 'spec_helper'))

begin
  require base_app_spec_helper
rescue LoadError => e
  puts "You need to install rspec in your base app (can't find #{base_app_spec_helper})"
  puts e.backtrace.join("\n")
  exit
end
