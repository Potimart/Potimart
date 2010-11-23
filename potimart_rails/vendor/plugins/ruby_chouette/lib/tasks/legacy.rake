namespace "agilis:db:chouette" do

  def deprecated_task(name, new_name = name)
    new_name = "db:chouette:#{new_name}"
    task name => new_name do
      puts "done ** DEPRECATED task, please use #{new_name}"
    end
  end

  deprecated_task :denormalize
  deprecated_task :migrate
  deprecated_task :generate_dates, :dates
  deprecated_task :load_cities, :cities

  task "schema:dump" do
    raise "Removed task"
  end
end
