# Defines a new sequence
Factory.sequence :name do |n|
  "Indicator#{n}"
end

Factory.define :line_indicator do |line_indicator|
  line_indicator.name { Factory.next(:name) }
  line_indicator.value  2
  line_indicator.association :line_id, :factory => :line
end
