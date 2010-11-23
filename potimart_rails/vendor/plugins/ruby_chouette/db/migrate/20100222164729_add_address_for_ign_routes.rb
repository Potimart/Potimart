class AddAddressForIgnRoutes < ActiveRecord::Migration
  def self.up
    add_column :ign_routes, :address_id, :integer
  end

  def self.down
    remove_column :ign_routes, :address_id
  end
end
