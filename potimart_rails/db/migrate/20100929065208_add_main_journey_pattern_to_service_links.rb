class AddMainJourneyPatternToServiceLinks < ActiveRecord::Migration
  def self.up
    add_column :service_links, :main_journey_pattern, :boolean
  end

  def self.down
    remove_column :service_links, :main_journey_pattern
  end
end
