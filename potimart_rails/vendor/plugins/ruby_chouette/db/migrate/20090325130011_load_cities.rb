class LoadCities < ActiveRecord::Migration
  def self.up
    root_path = File.dirname(File.dirname(File.dirname(__FILE__)))
    City.load(File.join(root_path,"insee", "ville.csv"))
  end

  def self.down
  end
end
