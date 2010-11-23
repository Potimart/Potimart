class LoadTransportModeForStoparea < ActiveRecord::Migration
  def self.up
    StopArea.denormalize_transport_mode
  end

  def self.down
  end
end
