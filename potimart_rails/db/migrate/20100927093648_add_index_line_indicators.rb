class AddIndexLineIndicators < ActiveRecord::Migration
  def self.up
    # Create an index on the table:
    add_index :line_indicators, [:name]
  end

  def self.down
    # Remove an index on the table:
    remove_index :line_indicators, [:name]
  end
end
