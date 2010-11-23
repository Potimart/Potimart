module Chouette::Batches

  def find_each(options = {})
    find_in_batches(options) do |records|
      records.each { |record| yield record }
    end
 
    self
  end

  def find_in_batches(options = {})
    start = 0
    batch_size = 1000
    with_scope(:find => options.merge(:order => batch_order, :limit => batch_size)) do
      records = find(:all, :conditions => [ "#{table_name}.#{primary_key} >= ?", start ])
      
      while records.any?
        yield records
        
        break if records.size < batch_size
        records = find(:all, :conditions => [ "#{table_name}.#{primary_key} > ?", records.last.id ])
      end
    end
  end

  private

  def batch_order
    "#{table_name}.#{primary_key} ASC"
  end

end
