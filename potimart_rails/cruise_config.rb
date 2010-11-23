Project.configure do |project|
  project.email_notifier.emails = ['luc.donnet@dryade.net', 'alban.peignier@dryade.net']
  project.email_notifier.from = 'dryade-admins@tryphon.org'

  # Build the project by invoking rake task 'custom'
  #project.rake_task = 'cruise'

  project.build_command = './script/cruise_build_command'

  # Ping for new revisions :
  # * every 5 minutes for pending projects
  # * 30 for other
  project.scheduler.polling_interval = 10.minutes

  project.campfire_notifier.account = 'dryade'
  # Use CruiseControl API token :
  project.campfire_notifier.token = 'd4e41a5bba3ac270da250b35ea66cc90d2549e40'
  project.campfire_notifier.room = 'Dryade'
end
