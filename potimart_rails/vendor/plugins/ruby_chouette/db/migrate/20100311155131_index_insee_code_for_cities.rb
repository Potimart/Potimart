class IndexInseeCodeForCities < ActiveRecord::Migration
  def self.up
    add_index :cities, :insee_code
  end

  def self.down
    remove_index :cities, :insee_code
  end
end
