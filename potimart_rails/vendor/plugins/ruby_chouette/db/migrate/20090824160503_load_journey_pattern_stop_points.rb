class LoadJourneyPatternStopPoints < ActiveRecord::Migration
  def self.up
    JourneyPatternStopPoint.load if (StopArea.commercial.count<10000)
  end

  def self.down
  end
end
