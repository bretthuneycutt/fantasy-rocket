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
      puts "- sending to league #{l.id} - #{l.name}"

      WeeklyDigestMailerWorker.perform_async(week, l.id)

      weekly_digests_sent += 1
    end

    puts "Week #{week} - #{weekly_digests_sent} weekly digests sent"
  end
end

namespace :leagues do
  desc 'Create 2014 leagues'
  task :create_2014 => :environment do
    League.season('2013').find_each do |l|
      l.create_next!({
        name: "#{l.name} - 2014",
        commissioner_id: l.commissioner_id,
        sport: l.sport,
        season: '2014',
      })

      puts "League: #{l.name}"
    end
  end

  desc 'Send 2014 email'
  task :email_2014 => :environment do
    League.season('2013').find_each do |l|
      SeasonMailerWorker.perform_async(l.id)

      puts "League: #{l.name}"
    end
  end
end

