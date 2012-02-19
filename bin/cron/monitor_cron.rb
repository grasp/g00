require 'rubygems' unless defined?(Gem)
require 'forever'
require 'logger'
logger=Logger.new("monitor.log")
Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__
 every 5.minutes do
    check_process=`ps -ef |grep cron`
 unless check_process.match(/scan_remove_cron\.rb/m)
`ruby /opt/vob/g00/bin/cron/scan_remove_cron.rb` #ugly hard code
 logger.info "try start scan_remove_cron cron #{Time.now}"
end

     unless check_process.match(/daily_backup_cron\.rb/m)
`ruby /opt/vob/g00/bin/cron/daily_backup_cron.rb` #ugly hard code
 logger.info "try start daily_backup_cron cron #{Time.now}"
end


  end
  
  
    on_error do |e|
    puts "Boom raised: #{e.message} #{Time.now}"
  end

  on_exit do
    puts "Bye bye on #{Time.now}"
  end
end
