# coding: utf-8
class AdminController < ApplicationController
  layout "admin"
  include Tf56graspHelper
  include QuzhougraspHelper
  include ScansHelper
  include AdminHelper
  #   before_filter:admin_authorize,:except=>[:index] #for debug purpose
  before_filter:admin_authorize, :except=>[:grasp_tf56,:grasp_quzhou,:scan,:move,:dev_expire] #for debug purpose
  def index
    @today=Hash.new
    @today["huo"]=Cargo.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["che"]=Truck.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["quote"]=Quote.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["inquery"]=Inquery.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["user"]=User.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["company"]=Company.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count

    @yesterday=Hash.new
    @yesterday["huo"]=Cargo.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    @yesterday["che"]=Truck.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    @yesterday["quote"]=Quote.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    @yesterday["inquery"]=Inquery.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    @yesterday["user"]=User.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    @yesterday["company"]=Company.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
    
    #some site data
    @sitedata = Sitedatum.all
  end
  
  def tf56grasp
    @grasps=GraspRecord.where(:from_site=>"tf56").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def quzhougrasp
    @grasps=GraspRecord.where(:from_site=>"quzhou").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end  

  def scan
    scan_helper
  end
  def scan_info
    @scans=Scan.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
  end
  def move
    move_helper    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @moves }
    end
  end
  
  def moveinfo
    @moves=Move.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def cargo_manage
    puts "run cargo manager"
    # @cargos = Cargo.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    #@cargos = Cargo.all.limit(100).paginate(:page=>params[:page]||1,:per_page=>20)
    @cargos = Cargo.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
  end

  def stockcargo_manage
    @stock_cargos = StockCargo.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def truck_manage
    @trucks = Truck.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def stocktruck_manage
    @stock_trucks = StockTruck.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def inquery_manage
    @inqueries = Inquery.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end
  def quote_manage
    @quotes = Quote.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def usercontact_manage
    @user_contacts = UserContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def user_manage
    @users = User.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def company_manage
    @companies = Company.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def get_room_contact
    a=[Cargo,Truck,ExpiredCargo,ExpiredTruck]
    a.each do |records|
      records.where("from_site"=>"tf56").each do |record|
        unless record.comments.blank?
          room=record.comments.to_s.split(/\s/)[0].strip.slice(0,6)
          contact=record.comments.gsub(room,"").strip
          check=RoomContact.where("room"=>room).first
          RoomContact.create("room"=>room,"contact"=>contact,"from"=>room.gsub(/\w||\d/,"").split[0].strip) if  (!room.blank? && contact.size>4 && check.blank?)
        end
      end
    end

    @rooms=RoomContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def show_room_contact
    @rooms=RoomContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html { render :action => '/admin/get_room_contact' }
    end
  end
  def grasp_tf56
    get_tf56_grasps
  end

  def grasp_quzhou
    get_quzhou_grasps
  end
  def show_cron_mail
    @log=`cat /var/mail/hunter`
    @logs=@log.split("\n")
  end
  def daily_trends
    show_daily_trends
  end

  def hourly_trends
    show_hourly_trends
  end

  def request_log_analysis
    helper_request_log_analysis
  end

  def show_log
    if params[:logfile]=="access"
      send_file "/var/log/rails/access.log", :type=>"application/log"
    elsif params[:logfile]=="mongodb"
      send_file "/var/log/mongodb/mongodb.log", :type=>"application/log"  
    elsif params[:logfile]=="mongodb"
      send_file "/var/log/mongodb/mongodb.log", :type=>"application/log"  
    elsif params[:logfile]=="thin3000"
      send_file "/opt/vob/g00/log/thin.3000.log", :type=>"application/log"  
    elsif params[:logfile]=="production"
      send_file "/var/log/rails/production.log", :type=>"application/log"  
    elsif params[:logfile]=="cron"
      send_file "/var/mail/hunter", :type=>"application/log"  
    elsif params[:logfile]=="development"
      send_file "/opt/vob/tmp/g00/log/development.log", :type=>"application/log"  
    elsif params[:logfile]=="dev-thin"
      send_file "/opt/vob/tmp/g00/log/thin.log", :type=>"application/log"  
    else      
      puts "show all file"
    end
  end

  def backup_db
    `cd`
    `mongodump -o /home/hunter/dump`
    `tar -zcf /home/hunter/dump_#{Time.now.to_s.slice(0,10)}.tgz /home/hunter/dump`
    send_file "/home/hunter/dump_#{Time.now.to_s.slice(0,10)}.tgz", :type=>"application/tgz"
  end
  
  def expire_city_navi

    expire_fragment  "cargos_allcity_1"
    expire_fragment  "trucks_allcity_1"
    expire_fragment  "provincecargo"
    expire_fragment  "provincetruck"
  
  end
  
  def dev_expire
    expire_fragment  "cargos_allcity_1"
    expire_fragment  "trucks_allcity_1"
    expire_fragment  "provincecargo"
    expire_fragment  "provincetruck"
    
    expire_fragment "userlines_all"
    expire_fragment "yellowpage"
    expire_fragment  "users_center_#{session[:user_id]}"
  
    # $city_code_name.each do |code,name| 
    #       expire_fragment "cargo_city_#{code}_" #if fragment_exist?("cargo_city_#{code}_")
    #       expire_fragment "truck_city_#{code}_" #if fragment_exist?("cargo_city_#{code}_")
    #  end

    # $city_code_name.each do |code,name| 
    #      expire_fragment "cargo_city_#{code}_city" # if fragment_exist?("cargo_city_#{code}_")#this is for region code is same as city code issue
    #      expire_fragment "truck_city_#{code}_city"# if fragment_exist?("cargo_city_#{code}_")
    # end
    $citytree.each do |key1,value1|
      expire_fragment "truck_city_#{key1}_"
      expire_fragment "cargo_city_#{key1}_"
      value1.each do |key2,value2|
        expire_fragment "truck_city_#{key2}_"
        expire_fragment "cargo_city_#{key2}_"
        value2.each do |key3,value3|
          expire_fragment "truck_city_#{key3}_city"
          expire_fragment "cargo_city_#{key3}_city"
        end
      end
  
    end
  end
  
  def deploy
    if Time.now.min==0||Time.now.min==1||Time.now.min==2
      @error="not right time to deploy"   
    elsif request.url.to_s.match("4500")
      unless Object::RUBY_PLATFORM.match("linux").nil?
        @log= `/opt/vob/deploy.sh`
      end
    else
      @error="not allowed deploy production in production mode!"
    end
  end
  
  def deploy_test
    unless  request.url.to_s.match("4500")
      unless Object::RUBY_PLATFORM.match("linux").nil?
        @log= `/opt/vob/deploy_test.sh`
      end
    else
      @error="not allowed deploy  test in test mode!"
    end
  end
  
  def sync_database
    unless Object::RUBY_PLATFORM.match("linux").nil?
      @log= `/opt/vob/sync_database.sh`
    end
  end
  
  def send_site_update_to_register

    start_time=Time.now

    #each time we send to 1 at first
    User.where(:inviten=>nil,:status.ne=>"disabled").limit(10).each do |user|
      puts  user.name
      begin  
        if params[:test]=="test"
          @user=User.where(:email=>"hunter.wxhu@gmail.com").first
        else
          @user=user 
        end     
        Notifier.send_site_update_to_register(@user).deliver!
        @result="成功发送"
    
        @user.inc(:inviten,1)
      rescue
        @result="发送失败"
        @user.inc(:inviten,10000)
      end
    end

    @inviten0=User.where(:inviten=>nil).count
    @inviten1=User.where(:inviten=>1).count
    @inviten2=User.where(:inviten=>2).count
    @send_time=Time.now-start_time
  end
  
  def temp_task
    Cargo.where(:status=>"正在配车").each do |cargo|
      cargo.update_attribute(:line,cargo.fcity_code+"#"+cargo.tcity_code)
    end
  end

end