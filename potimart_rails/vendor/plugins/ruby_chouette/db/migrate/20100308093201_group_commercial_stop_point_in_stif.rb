class GroupCommercialStopPointInStif < ActiveRecord::Migration
  def self.up
    StopArea.compute_stop_place(0.6) if (StopArea.commercial.count>10000)
  end

  def self.down
  end
end
