class LineIndicator < ActiveRecord::Base
  belongs_to :line
  named_scope :by_name, lambda{|name| {:conditions => ['name = ?', name]}}

  def self.create_test_indicator(name)
    LineIndicator.transaction do
      Line.find(:all).each do |line|
        LineIndicator.create!:line_id => line.id,
          :name => name,
          :value => rand(6000)
      end
    end
  end

  def self.names()
    LineIndicator.find_by_sql "SELECT DISTINCT line_indicators.name FROM line_indicators "
  end

end
