class CreateAddressSections < ActiveRecord::Migration
  def self.up
    create_table :address_sections do |t|
      t.belongs_to :address
      t.belongs_to :ign_route
      t.integer :number_begin, :number_end
    end 
  end

  def self.down
    drop_table :address_sections
  end
end
