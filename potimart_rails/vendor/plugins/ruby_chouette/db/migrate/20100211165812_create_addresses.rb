class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :name
      t.integer :number_begin, :number_end
      t.belongs_to :city
    end 
  end

  def self.down
    drop_table :addresses
  end
end
