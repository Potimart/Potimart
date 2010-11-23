class RemoveAddressIdFromIgnRoutes < ActiveRecord::Migration

  def self.up
    if columns(:ign_routes).include?(:address_id)
      remove_column :ign_routes, :address_id
    end
  end

  def self.down
    add_column :ign_routes, :address_id, :integer
  end

end
