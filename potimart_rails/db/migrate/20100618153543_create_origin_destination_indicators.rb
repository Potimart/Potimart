class CreateOriginDestinationIndicators < ActiveRecord::Migration
  def self.up
    create_table :origin_destination_indicators do |t|
      t.string :name
      t.integer :value
      t.integer :stoparea_start_id
      t.integer :stoparea_end_id
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :origin_destination_indicators
  end
end
