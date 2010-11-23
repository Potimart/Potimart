# Defines a new sequence
Factory.sequence :name do |n|
  "Line#{n}"
end

Factory.define :line do |line|
  line.name { Factory.next(:name) }
end