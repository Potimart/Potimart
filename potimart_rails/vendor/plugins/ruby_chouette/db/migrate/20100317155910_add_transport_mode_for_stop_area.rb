class AddTransportModeForStopArea < ActiveRecord::Migration
  def self.up
    add_column :stoparea, :modes, :integer, :default => 0
  end

  def self.down
    remove_column :stoparea, :modes
  end
end
