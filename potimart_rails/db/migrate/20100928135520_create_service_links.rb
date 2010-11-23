class CreateServiceLinks < ActiveRecord::Migration
  def self.up
    rename_table :pathlinks, :service_links
  end

  def self.down
    rename_table :service_links, :pathlinks
  end
end
