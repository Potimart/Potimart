# -*- coding: utf-8 -*-
module Chouette::Geocoder
  class Location < ChouetteActiveRecord
    set_table_name :geocoder_locations
    extend ActiveSupport::Memoizable

    belongs_to :reference, :polymorphic => true
    belongs_to :zone

    def reference_with_geocoding(geocoding = nil)
      reference = reference_without_geocoding
      if geocoding and Road === reference 
        reference = Address.new(reference, geocoding.street_number) 
      end
      reference
    end
    alias_method_chain :reference, :geocoding

    def self.from(reference, attributes = {})
      unless Location === reference
        Location.new({:reference => reference}.update(attributes))
      else
        unless attributes.empty?
          reference = reference.dup
          reference.attributes = attributes
        end

        reference
      end
    end

    def reference_with_update=(reference)
      if ActiveRecord::Base === reference
        self.reference_without_update = reference 
      end

      if reference
        self.name ||= reference_name(reference)
        self.zone ||= reference_zone(reference)
      end
    end
    alias_method_chain :reference=, :update

    def uid
      if reference_type
        "#{self.reference_type}:#{self.reference_id}".hash
      else
        to_s.hash
      end
    end
    memoize :uid

    def reference_name(reference)
      reference.respond_to?(:name) ? reference.name : reference.to_s
    end

    def reference_zone(reference)
      reference.respond_to?(:city) ? Zone.find_by_city(reference.city) : nil
    end

    def before_save
      self.stored_words = Word.serialize(words)
      self.stored_phonetics = Phonetic.serialize(phonetics)
    end

    def to_s
      unless zone 
        name
      else
        "#{name}, #{zone}"
      end
    end

    def eql(other)
      other and self.uid == other.uid
    end
    alias_method :==, :eql

    def words
      unless stored_words.blank?
        Word.unserialize(stored_words)
      else
        name.to_words
      end
    end
    memoize :words

    def phonetics
      unless stored_phonetics.blank?
        Phonetic.unserialize(stored_phonetics)
      else
        words.collect(&:phonetics).flatten
      end
    end
    memoize :phonetics

    def zone_words
      zone ? zone.words : []
    end
    memoize :zone_words

    def self.create_all
      Location.transaction do 
        Road.find_each do |road|
          Location.from(road).save!
        end
        (StopArea.commercial.without_parent + StopArea.stop_place.without_parent).each do |stop_area|
          Location.from(stop_area).save!
        end
        Place.find_each do |place|
          Location.from(place).save!
        end
      end
    end

    def self.references(locations)
      Location.find(locations, :include => "reference").sort_by do |location|
        locations.index(location)
      end.collect!(&:reference)
    end

  end
end
