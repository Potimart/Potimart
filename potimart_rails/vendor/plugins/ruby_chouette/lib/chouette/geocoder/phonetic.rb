module Chouette::Geocoder
  class Phonetic < StringContainer

    # Metaphone rules.  These are simply applied in order.
    #
    STANDARD = [ 
                # Regexp, replacement
                [ /([bcdfhjklmnpqrstvwxyz])\1+/,
                  '\1' ],  # Remove doubled consonants except g.
                # [PHP] remove c from regexp.
                [ /^ae/,            'E' ],
                [ /^[gkp]n/,        'N' ],
                [ /^wr/,            'R' ],
                [ /^x/,             'S' ],
                [ /^wh/,            'W' ],
                [ /mb$/,            'M' ],  # [PHP] remove $ from regexp.
                [ /(?!^)sch/,      'SK' ],
                [ /th/,             'T' ],
                [ /t?ch|sh/,        'X' ],
                [ /c(?=ia)/,        'X' ],
                [ /[st](?=i[ao])/,  'X' ],
                [ /s?c(?=[iey])/,   'S' ],
                [ /[cq]/,           'K' ],
                [ /dg(?=[iey])/,    'J' ],
                # [ /d/,              'T' ],
                [ /g(?=h[^aeiou])/, ''  ],
                [ /gn(ed)?/,        'N' ],
                [ /([^g]|^)g(?=[iey])/,
                  '\1J' ],
                # [ /g+/,             'K' ],
                [ /ph/,             'F' ],
                [ /^h([aeiou])/,     '\1' ],
                [ /([aeiou])h(?=\b|[^aeiou])/,
                  '\1' ],
                [ /[wy](?![aeiou])/, '' ],
                [ /z/,              'S' ],
                [ /v/,              'F' ],
                [ /(?!^)[aeiou]+/,  ''  ],
               ]

    # Returns the Metaphone representation of a string. If the string contains
    # multiple words, each word in turn is converted into its Metaphone
    # representation. Note that only the letters A-Z are supported, so any
    # language-specific processing should be done beforehand.
    #
    # If the :buggy option is set, alternate 'buggy' rules are used.
    #
    def self.metaphone(str, options={})
      return str.strip.split(/\s+/).map { |w| metaphone_word(w, options) }.join(' ')
    end

    def self.phonetics(*strings)
      strings.flatten.collect! do |string|
        Phonetic.metaphone string.to_s
      end.flatten.delete_if { |p| p.blank? }.collect! do |s|
        Phonetic.to_phonetic(s)
      end
    end

    def self.to_phonetic(string)
      Phonetic.new(string)
    end
    
    def self.metaphone_word(w, options={})
      # Normalise case and remove non-ASCII
      s = w.downcase.gsub(/[^a-z]/, '')
      # Apply the Metaphone rules
      STANDARD.each { |rx, rep| s.gsub!(rx, rep) }
      return s.upcase
    end

    def self.unserialize(serialized_phonetics)
      serialized_phonetics.split(' ').collect! do |serialized_phonetic|
        Phonetic.to_phonetic(serialized_phonetic)
      end
    end

  end
end
