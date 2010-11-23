namespace :gems do
  def install(*arguments)
    options = 
      arguments.last.is_a?(Hash) ? arguments.pop : {}
    gems = arguments
    
    gem_command = "gem install #{gems.join(' ')}"
    gem_command << " --source #{options[:source]}" if options[:source]
    sh "sudo #{gem_command}"
  end

  desc "Install required gems"  
  task :install do
    install 'activerecord', 'actionpack'
    install 'geokit'
    install 'shuber-acts_as_tree', 'ryanb-acts-as-list', :source => "http://gems.github.com"
    install 'albanpeignier-geokit-rails', 'albanpeignier-searchapi', :source => "http://gems.github.com"

    install 'rspec', 'rspec-rails'
    install 'thoughtbot-factory_girl', :source => 'http://gems.github.com'
  end
end
