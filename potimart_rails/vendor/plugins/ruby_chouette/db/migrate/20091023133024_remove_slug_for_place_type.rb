class RemoveSlugForPlaceType < ActiveRecord::Migration
  def self.up
    remove_column :place_types, :slug
  end

  def self.down
    add_column :place_types, :slug, :string
  end
end
