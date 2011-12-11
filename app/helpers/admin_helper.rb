module AdminHelper
  #get a stupid map at first
  $table_map={
    "cargo"=>Cargo,
    "truck"=>Truck,
    "stocktruck"=>StockTruck,
    "stockcargo"=>StockCargo,
    "user"=>User,
    "company"=>Company,
    "quote"=>Quote,
    "inquery"=>Inquery
  }

  def show_daily_trends
    start_time=Time.now
    @trends=Hash.new
    @title=params[:table]
    @max=0
    (params[:day].to_i).downto(1).each do |i|
      begin_time=(start_time-(86400*(i-1))).at_midnight()
      end_time=begin_time-86400
      if params[:field]
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time,params[:field]=>params[:value]).count
      else
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time).count
      end
      #counter=100
      @trends[begin_time.to_s]=counter
      @max=@trends[begin_time.to_s] if @max<counter
    end
    #sort
    @trends=@trends.to_a.reverse!
  end

  def show_hourly_trends
    start_time=(Time.parse(params[:day])+86400).at_midnight
    @trends=Hash.new
    @title=params[:table]
    @max=0
    (24).downto(1).each do |i|
      begin_time=(start_time-(3600*(i-1)))
      end_time=begin_time-3600
      if params[:field]
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time,params[:field]=>params[:value]).count
      else
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time).count
      end
      #counter=100
      @trends[begin_time.to_s]=counter
      @max=@trends[begin_time.to_s] if @max<counter
    end
    #sort
    @trends=@trends.to_a.reverse!
  end
  
  def helper_request_log_analysis

    @all_log_file=Array.new
    
     $production_log="/var/log/rails/production.log"
    unless File.exist?($production_log)
      params[:logfile]="development"+".log" if  params[:logfile].nil?
      $production_log="/var/log/rails/production.log"
    end
    
    unless File.exist?($production_log)
      params[:logfile]="development.log" if  params[:logfile].nil?
      $production_log="/var/log/rails/production.log"
    end
    @all_log_file<< $production_log
     @all_log_file<< "/var/log/nginx/access.log"
     
    if params[:all]
      @all_log_file=Array.new
      $production_log=String.new
      $production_log="/var/log/rails/production.log"
    else
      $production_log="/var/log/rails/production.log"
    end
    
   # @command="request-log-analyzer #{$production_log} --output html"
    @production_analysis=`request-log-analyzer /var/log/rails/production.log --output html`
    if File.exist?("/var/log/rails/production.log.1")
    @production_analysis1=`request-log-analyzer /var/log/rails/production.log.1 --output html`
    end
    @access_analysis =`request-log-analyzer /var/log/nginx/access.log --output html`
     if File.exist?("/var/log/nginx/access.log.1")
   @access_analysis1 =`request-log-analyzer /var/log/nginx/access.log.1 --output html`
     end
  end


  

end
