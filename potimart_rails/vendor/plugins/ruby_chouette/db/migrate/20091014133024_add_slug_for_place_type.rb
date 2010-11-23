class AddSlugForPlaceType < ActiveRecord::Migration
  def self.up
    add_column :place_types, :slug, :string
  end

  def self.down
    remove_column :place_types, :slug
  end
end
