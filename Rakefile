# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

FantasyRocket::Application.load_tasks

namespace :digest do
  desc 'Syntax: rake digest:send_weekly WEEK=1'
  task :send_weekly => :environment do
    raise ArgumentError  unless !!ENV['WEEK']

    week = ENV['WEEK'].to_i

    weekly_digests_sent = 0

    puts "Week #{week} - starting to send weekly digests"

    League.draft_complete.find_each do |l|
      puts "- sending to league #{l.d} - #{l.name}"

      WeeklyDigestMailerWorker.perform_async(week, l.id)

      weekly_digests_sent += 1
    end

    puts "Week #{week} - #{weekly_digests_sent} weekly digests sent"
  end
end

