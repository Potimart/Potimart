# Project-specific configuration for CruiseControl.rb

Project.configure do |project|
  
  # Send email notifications about broken and fixed builds to email1@your.site, email2@your.site (default: send to nobody)
  project.email_notifier.emails = project.email_success_notifier.emails = ['alban.peignier@dryade.net', 'marc.florisson@dryade.net']

  # Set email 'from' field to john@doe.com:
  project.email_notifier.from = project.email_success_notifier.from = 'alban.peignier@dryade.net'

  # Build the project by invoking rake task 'custom'
  #project.rake_task = 'cruise'

  # Build the project by invoking shell script "build_my_app.sh". Keep in mind that when the script is invoked,
  # current working directory is <em>[cruise&nbsp;data]</em>/projects/your_project/work, so if you do not keep build_my_app.sh
  # in version control, it should be '../build_my_app.sh' instead
  project.build_command = './script/cruise_build_command'

  # Ping Subversion for new revisions every 5 minutes (default: 30 seconds)
  project.scheduler.polling_interval = 5.minutes

  project.campfire_notifier.account = 'dryade'
  # Use CruiseControl API token :
  project.campfire_notifier.token = 'd4e41a5bba3ac270da250b35ea66cc90d2549e40'
  project.campfire_notifier.room = 'Agilis'
  project.campfire_notifier.ssl = false

end
