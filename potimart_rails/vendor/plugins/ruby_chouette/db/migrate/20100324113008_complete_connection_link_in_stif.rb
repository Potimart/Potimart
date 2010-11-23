class CompleteConnectionLinkInStif < ActiveRecord::Migration
  def self.up
    ConnectionLink.load_stop_area_proximity(0.4) if (StopArea.commercial.count>10000)
  end

  def self.down
  end
end
