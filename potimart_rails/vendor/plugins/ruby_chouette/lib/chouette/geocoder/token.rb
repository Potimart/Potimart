# -*- coding: utf-8 -*-
module Chouette::Geocoder
  class Token < StringContainer

  def inspect
    "token:#{string}"
  end

  def to_word
    Word.to_word self
  end

  @@tokenizer_replacements = { 
    /â|à/ => 'a', 
    /ê|è|é|ë/ => 'e', 
    /î|ï/ => 'i', 
    /ô|ö/ => 'o', 
    /û|ù|ü/ => 'u',
    /ç/ => 'c',
    /\./ => '' # create a token with acronym
  }

  def self.tokenize(string)
    @@tokenizer_replacements.inject(string) do |string, entry|
      string.gsub(*entry)
    end.upcase.gsub(/[^A-Z0-9]/, ' ').split.collect! do |token_string|
      Token.new token_string
    end
  end

  def self.token(string)
    return string if string.nil? or Token === string

    tokens = tokenize(string)
    raise "several tokens found into '#{string}'" if tokens.many?
    tokens.first
  end

end
end
