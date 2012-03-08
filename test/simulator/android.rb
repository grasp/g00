require 'rubygems'
require "mechanize"
require 'active_support'

	def background_every_n_seconds(n)
	  mechanize=Mechanize.new
      lng=116.46
      lat=39.92
      speed=60
	    loop do
	      before = Time.now
	      yield
	      interval = n-(Time.now-before)        
	      sleep(interval) if interval > 0
        lat=lat+0.1
        lng=lng+0.1
        lat=116.46 if lat > 170
       lng=39.92  if lng > 170
        begin
      post_gps(mechanize,"12787651235",lat,lng,speed) 
        rescue
          puts "post error #{$@}!!"
        end
	    end
	#  end
	end
  
  def post_gps(mechanize,mobile_phone,lat,lng,speed)     
location=Hash.new
location[:mphone]=mobile_phone
location[:lat]=lat
location[:lng]=lng
location[:speed]=speed
  #   mechanize.get(CGI::escape("http://localhost:4500/dingwei/postgps/mphone/#{mobile_phone}/lat/#{lat}/lng/#{lng}/speed/#{speed}"))
  #mechanize.get("http://localhost:4500/dingwei/postgps/mphone/#{mobile_phone}/lat/#{lat}/lng/#{lng}")
  
  result= mechanize.post("http://localhost:4500/dingwei/post_gps",:location=>location)
# puts  eval(result.body).to_hash
 parsed_json = ActiveSupport::JSON.decode(result.body)
 puts parsed_json["bind"]
  end

	background_every_n_seconds(2*5) { puts 'Get back to work!' ;}




