# -*- coding: utf-8 -*-
class PlaceType < ChouetteActiveRecord
  validates_uniqueness_of :name 
  has_many :places
  
  named_scope :include_names, lambda { |names| { :conditions => [ "name IN (?)",  names], :order => :name }}
  named_scope :exclude_names, lambda { |names| { :conditions => [ "NOT name IN (?)",  names], :order => :name }}
  
  def to_json
    { :id => self.id, :name => self.name}.to_json
  end
end
