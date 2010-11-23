class CreateLineIndicators < ActiveRecord::Migration
  def self.up
    create_table :line_indicators do |t|
      t.string :name
      t.integer :value
      t.integer :line_id
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :line_indicators
  end
end
