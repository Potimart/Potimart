module AreaSearch
  include FrenchText
  
  def find_by_name(search_string, options={})
    # Very small sanitization of search string
    search_string = search_string.tr('();[]',' ')

    with_scope(:find => options) do
      [search_string.strip.split(' '), search_string].flatten.map do |string_part|
        self.find(:all, :conditions => ["name ~* ?", ignore_accents_pattern(string_part)]).uniq
      end.flatten
    end
  end
  
  def find_by_city(string, options={})
    results = []
    city_ids = StopArea.all_cities.map(&:id)
    
    string.strip.split(' ').each do |string_part|
      city_country_codes = City.find_by_name( string_part, city_ids).map(&:insee_code).map(&:to_s).uniq.flatten
      # format city_country_code with 5 digits
      city_country_codes = city_country_codes.map { |code| sprintf("%05d", code)}
      string_part_results = with_scope(:find => options) do
        self.all_from_cities(city_country_codes).uniq
      end
      results << string_part_results.flatten
      
      # here all stop_areas belong to a city whose name matches string_part
      # repeat stop_area if its name matches remaining string (string - string_part)
      remaining_search_string = string.gsub(string_part, '').strip
      unless remaining_search_string.blank?
        
        results.unshift(string_part_results.find_all do |stop_area|
          # remaining_search_string may contain many unordered words
          # test if at least one word does match
          stop_area.name.match(Regexp.new(remaining_search_string.gsub(/ /, '|'), 'i'))
        end.uniq)
      end
    end
    
    results.flatten
  end
  
end
