class IndexAddressIdForAddressSections < ActiveRecord::Migration
  def self.up
    add_index :address_sections, :address_id
  end

  def self.down
    remove_index :address_sections, :address_id
  end
end
