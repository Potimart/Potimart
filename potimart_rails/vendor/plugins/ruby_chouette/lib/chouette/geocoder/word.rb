# -*- coding: utf-8 -*-
module Chouette::Geocoder
  class Word < StringContainer

    def inspect
      "word:#{string}"
    end

    def to_word
      self
    end

    @@instances = {}
    def self.to_word(string)
      token = Token.token(string)
      @@instances[token.to_s] ||= Word.new(token)
    end

    def self.to_words(elements)
      elements = WordParser.new(elements).words if String === elements
      elements.collect(&:to_word)
    end

    def self.clear_instances
      @@instances = {}
    end

    def self.unserialize(serialized_words)
      serialized_words.split(' ').collect do |serialized_word|
        @@instances[serialized_word] ||= Word.new(serialized_word)
      end
    end

  end
end
