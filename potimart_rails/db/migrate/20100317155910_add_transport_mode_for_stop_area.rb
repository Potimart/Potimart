class AddTransportModeForStopArea < ActiveRecord::Migration
  def self.up
    add_column :stoparea, :modes, :integer, :default => 0 if table_exists?(:stoparea)
  end

  def self.down
    remove_column :stoparea, :modes if table_exists?(:stoparea)
  end
end
