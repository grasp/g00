#coding:utf-8
class ConcerncargosController < ApplicationController
  include CitiesHelper
  # GET /concerncargos
  # GET /concerncargos.xml
  
  layout :choose_layout 
  
  def choose_layout
    return  "concerncargos"
  end
  def index
    @concerncargos = Concerncargo.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @concerncargos }
    end
  end
  
  def userconcern
    if session[:user_id]
     
      @concerncargo=Concerncargo.where(:user_id=>session[:user_id]).first
      unless @concerncargo.blank?        #to get all city cargo 
        @total_cargos=Hash.new
        unless @concerncargo.city.blank? 
          city_array=Array.new          
          @concerncargo.city.each  do |city|
            citycode=city[0]
            if is_region?(citycode)
              city_array=city_array.concat($region_code[citycode])
                city_array<<citycode
            else
             city_array<<citycode
            end
          end
       @cityconcerncargo=Cargo.where(:status=>"正在配车",:created_at.gte=>Time.now.at_beginning_of_day).any_in(:fcity_code=>city_array).desc(:created_at).limit(100)
         #    @cityconcerncargo=Cargo.where(:status=>"正在配车").any_in(:fcity_code=>city_array).desc(:created_at).limit(100)
        end      

        @total_cargos["关注城市"]= @cityconcerncargo
        
        unless @concerncargo.line.blank? 
          linearray=Array.new
          @concerncargo.line.each  do |linecode|
            linearray=linearray.concat(get_all_line_array(linecode[0]))
          end
        # log=Logger.new("line.log")
        # log.info   linearray
    @lineconcerncargo=Cargo.where(:status=>"正在配车",:created_at.gte=>Time.now.at_beginning_of_day).any_in(:line=>linearray).desc(:created_at).limit(10)
      # @lineconcerncargo=Cargo.where(:status=>"正在配车").any_in(:line=>linearray).desc(:created_at).limit(10)
          @count=@lineconcerncargo.count
        end       
        @total_cargos["关注线路"]= @lineconcerncargo
        
        unless @concerncargo.userid.blank? 
          user_array=Array.new
         
          @concerncargo.userid.each {|x| user_array<<x[3]}
          @userconcerncargo=Cargo.where(:status=>"正在配车",:created_at.gte=>Time.now.at_beginning_of_day).any_in(:user_id=>user_array).desc(:created_at).limit(10)
        end       
        @total_cargos["关注用户"]= @userconcerncargo
         
        unless @concerncargo.phone.blank? 
          phone_array=Array.new
          @concerncargo.phone.each {|x| phone_array<<x[0]}
          @phoneconcerncargo=Cargo.where(:status=>"正在配车",:created_at.gte=>Time.now.at_beginning_of_day).any_in(:phone=>phone_array).desc(:created_at).limit(10)
        end       
        @total_cargos["关注电话"]= @phoneconcerncargo
      end
   
    else
      session[:original_url]=request.url
      redirect_to userslogin_path,:flash=>{:notice=>" 添加你关注的城市，线路，用户和电话的货源信息，老客户的货源逃不掉，请先登录，谢谢！"}
    end
  end
  
  # GET /concerncargos/1
  # GET /concerncargos/1.xml
  def show
    if params[:id]=="my"
      if session[:user_id]
        @concerncargo=Concerncargo.where(:user_id=>session[:user_id].to_s).first
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @concerncargo }
    end
  end

  # GET /concerncargos/new
  # GET /concerncargos/new.xml
  def new
    concern_type=params[:concern_type]
    if session[:user_id]   
      @concerncargo = Concerncargo.new
    else
      flash[:notice]="注册用户才能够增加关注"
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @concerncargo }
    end
  end

  # GET /concerncargos/1/edit
  def edit
    if params[:id]=="my"
      if session[:user_id]
        @concerncargo=Concerncargo.where(:user_id=>session[:user_id].to_s).first
      else
        session[:original_url]=request.url
        redirect_to userslogin_path,:flash=>{:notice=>" 注册用户才能添加关注，花费数秒钟免费注册，从此尽可享受免费的精彩服务"}
      end
    end
  end

  # POST /concerncargos
  # POST /concerncargos.xml
  def create
    if session[:user_id]
      @concerncargo=Concerncargo.where(:user_id=>session[:user_id]).first
      #create a blank record if not created before
      if @concerncargo.blank?
        @concerncargo=Concerncargo.new         
      end
      @concerncargo.user_id=session[:user_id]
      
      unless @concerncargo.blank?
        if params[:concern_type]=="city" 
          #check unique for user?
          @concerncargo.city= Array.new   if  @concerncargo.city.blank?  
          if    @concerncargo.city.size<6
            @concerncargo.city<<[params[:citycode],false,false]    
            @concerncargo.city.uniq!   
          else
            flash[:notice]="添加关注失败，目前只能关注5个城市!"
            @error=true
          end
        end
        
        if params[:concern_type]=="line" 
          #check unique for user?
          @concerncargo.line= Array.new   if  @concerncargo.line.blank?  
          if @concerncargo.line.size<6
            @concerncargo.line<<[params[:fcitycode]+"#"+params[:tcitycode],false,false]    
            @concerncargo.line.uniq!    
          else
            flash[:notice]="添加关注失败，目前只能关注5条线路!"
            @error=true
          end
        end
        
        if params[:concern_type]=="user" 
          #check unique for user?
          @concerncargo.userid= Array.new   if  @concerncargo.userid.blank? 
          if  @concerncargo.userid.size<5
            user=User.where(:name=>params[:username]).first
            unless user.blank?
              unless params[:username]=="admin"
              @concerncargo.userid<<[params[:username],false,false,user.id.to_s]   #false, false, means mail and sms subscribe is not
              @concerncargo.userid.uniq! 
              else
               flash[:notice]="添加关注失败，你关注的用户名不存在!"
               @error=true
              end
            else
              flash[:notice]="添加关注失败，你关注的用户名不存在!"
              @error=true
            end
          else
            flash[:notice]="添加关注失败，目前只能关注5个用户!"
            @error=true
          end
        end
        
        if params[:concern_type]=="phone" 
          #check unique for user?
          @concerncargo.phone= Array.new   if  @concerncargo.phone.blank?  
          if @concerncargo.phone.size <10
            @concerncargo.phone<<[[params[:mobilephone],params[:quhao]+"-"+params[:fixphone],params[:email],params[:QQ],params[:comments]],false,false]
            @concerncargo.phone.uniq!    
          else
            flash[:notice]="添加关注失败，目前只能关注10个电话!"
            @error=true
          end
        end
        
      end
    end
    respond_to do |format|
      if @concerncargo.save
        flash[:notice]="成功添加关注!" unless @error
        format.html { redirect_to :action=>"userconcern" }
        format.xml  { render :xml => @concerncargo, :status => :created, :location => @concerncargo }
      else
        flash[:notice]="添加关注失败!"
        format.html { render :action => "new" }
        format.xml  { render :xml => @concerncargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /concerncargos/1
  # PUT /concerncargos/1.xml
  def update

    @concerncargo=Concerncargo.where(:user_id=>session[:user_id]).first
    
    #for city form update
    if params[:concern_type]=="city" && !@concerncargo.city.blank?
      (@concerncargo.city.size-1).downto(0).each do |index|
        if  params["delete#{index}"]    
        #  puts "delete#{index}="+params["delete#{index}"] 
          @concerncargo.city.delete_at(index)
        end
      end
      @concerncargo.update_attribute(:city,@concerncargo.city) 
    end
    
    if params[:concern_type]=="line" && !@concerncargo.line.blank?
      new_concerncargoline=Array.new 
      new_concerncargoline=@concerncargo.line
      (@concerncargo.line.size-1).downto(0).each do |index|
        if  params["mail#{index}"]    
          new_concerncargoline[index][1]=true
        else
          new_concerncargoline[index][1]=false
        end        
        new_concerncargoline.delete_at(index)  if  params["delete#{index}"]    
      end
      #this may be database bug,it could not update directly for element in array
      @concerncargo.update_attribute(:line,nil)
      @concerncargo.update_attribute(:line,new_concerncargoline)
    end
    
    if params[:concern_type]=="user" && !@concerncargo.userid.blank?
      new_concerncargouser=Array.new 
      new_concerncargouser=@concerncargo.userid
      (@concerncargo.userid.size-1).downto(0).each do |index|
        if  params["mail#{index}"]    
          new_concerncargouser[index][1]=true
        else
          new_concerncargouser[index][1]=false
        end        
        new_concerncargouser.delete_at(index)  if  params["delete#{index}"]    
      end
      #this may be database bug,it could not update directly for element in array
      @concerncargo.update_attribute(:userid,nil)
      @concerncargo.update_attribute(:userid,new_concerncargouser)
    end
    
    if params[:concern_type]=="phone" && !@concerncargo.phone.blank?
      new_concerncargophone=Array.new 
      new_concerncargophone=@concerncargo.phone
      (@concerncargo.phone.size-1).downto(0).each do |index|
        if  params["mail#{index}"]    
          new_concerncargophone[index][1]=true
        else
          new_concerncargophone[index][1]=false
        end        
        new_concerncargophone.delete_at(index)  if  params["delete#{index}"]    
      end
      #this may be database bug,it could not update directly for element in array
      @concerncargo.update_attribute(:phone,nil)
      @concerncargo.update_attribute(:phone,new_concerncargophone)
    end

    respond_to do |format|
      #  format.html { redirect_to concerncargosuserconcern_path}
      #format.html { redirect_to request.url}
      format.html { render :action=>"edit",:concern_type=>params[:concern_type]}
    end
    
    if false
      respond_to do |format|
        if @concerncargo.update_attributes(params[:concerncargo])
          format.html { redirect_to(@concerncargo, :notice => 'Concerncargo was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @concerncargo.errors, :status => :unprocessable_entity }
        end
      end
    end
  end


  # DELETE /concerncargos/1
  # DELETE /concerncargos/1.xml
  def destroy
    @concerncargo = Concerncargo.find(params[:id])
    @concerncargo.destroy

    respond_to do |format|
      format.html { redirect_to concerncargosuserconcern_path}
      format.xml  { head :ok }
    end
  end
end
