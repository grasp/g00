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
 
        
                unless @concerncargo.line.blank? 
          linearray=Array.new
          @concerncargo.line.each  do |linecode|
            linearray=linearray.concat(get_all_line_array(linecode[0])) #combine all together
          end
          @lineconcerncargo=Cargo.where(:status=>"正在配车",:created_at.gte=>Time.now.at_beginning_of_day).any_in(:line=>linearray).desc(:created_at).limit(10)
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
          if  @concerncargo.city.size<2 or session[:user_name]=="hunter"
            @concerncargo.city<<[params[:citycode],false,false]    
            @concerncargo.city.uniq!   
          else
            flash[:notice]="添加关注失败，目前只能关注2个城市!"
            @error=true
          end
        end
        
        if params[:concern_type]=="line" 
          #check unique for user?
          @concerncargo.line= Array.new   if  @concerncargo.line.blank?  
          if @concerncargo.line.size<5 or session[:user_name]=="hunter"
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
          if  @concerncargo.userid.size<5 or session[:user_name]=="hunter"
            user=User.where(:name=>params[:username]).first
            unless user.blank?
              unless params[:username]=="admin"
                @concerncargo.userid.each do |uid|
                  if  uid[0]==params[:username]
                    flash[:notice]="添加关注失败，重复关注!"
                    @error=true
                  end
                end
                unless @error==true
                  @concerncargo.userid<<[params[:username],false,false,user.id.to_s]    #false, false, means mail and sms subscribe is not
                  @concerncargo.userid.uniq! 
                end
                
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
          if @concerncargo.phone.size <10 or session[:user_name]=="hunter"
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
    @user=User.find(session[:user_id])
    
    #for city form update
    if params[:concern_type]=="city" && !@concerncargo.city.blank?
      new_concerncargocity=Array.new
      new_concerncargocity=@concerncargo.city
      
      (@concerncargo.city.size-1).downto(0).each do |index|
        #how to hanlde subcity
        
        subcity=get_sub_city(@concerncargo.city[index][0])
        all_cityconcern=Array.new
        
        subcity.each do |eachcity|
          cityconcern= Concerncityc.where(:city=>eachcity).first
          if cityconcern.blank? #initialize the cityconcern
            cityconcern=Concerncityc.new
            cityconcern.city=eachcity
            cityconcern.emaillist=Array.new      
            cityconcern.smslist=Array.new  
            cityconcern.save
          end
          all_cityconcern<<cityconcern
        end
        
        if  params["delete#{index}"]    #if delete we dont care about other checkbox  just remove 
          new_concerncargocity.delete_at(index)
          #remove email from city subscribe list
          all_cityconcern.each do |cityconcern|
            cityconcern.emaillist.delete(session[:user_email]) #remove email from list if have
            cityconcern.smslist.delete(session[:user_email]) #remove email from list if have
          end
        else #if not check delete
          if params["mail#{index}"]  #checked mail subscribe
         
            #delete if unsubscribe from list
            puts "email= #{@concerncargo.city[index][1]}"
            if @concerncargo.city[index][1]==false #not added into yet
              # puts "insert email!"
              all_cityconcern.each do |cityconcern|
                cityconcern.emaillist<<session[:user_email]    
              end
            else
              #  puts "already inserted email!"
            end
            new_concerncargocity[index][1]=true #must insert here, seemed will change the @concerncargo also,should refrence
          else
            if @concerncargo.city[index][1]==true
              #  puts "remove for uncheck"
              all_cityconcern.each do |cityconcern|
                cityconcern.emaillist.delete(session[:user_email])    
              end
            else
              #   puts "already deleted "
            end
            new_concerncargocity[index][1]=false
          end
          if params["sms#{index}"] #if checked sms subscribe
         
            if @concerncargo.city[index][2]==false #not added into yet
              all_cityconcern.each do |cityconcern|
                cityconcern.smslist<< @user.mobilephone      
              end
            end 
            new_concerncargocity[index][2]=true
          else
            if @concerncargo.city[index][2]==true
              #  puts "remove for uncheck"
              all_cityconcern.each do |cityconcern|
                cityconcern.smslist.delete(@user.mobilephone )    
              end
            else
              #   puts "already deleted "
            end
            new_concerncargocity[index][2]=false #we must  set this value at last 
          end
        
        end
        
        #now update subscribe list of city
        all_cityconcern.each do |cityconcern|
          #   cityconcern.save! 
          new_email_list=cityconcern.emaillist
          new_sms_list=cityconcern.smslist
          cityconcern.save
          #  cityconcern.update_attribute(:emaillist,nil)
          cityconcern.update_attribute(:emaillist,new_email_list) #we have to do this due to save not fetch array data,only save a empty array
          cityconcern.update_attribute(:smslist,new_sms_list)
        end

      end
      @concerncargo.update_attribute(:city,nil)
      @concerncargo.update_attribute(:city,new_concerncargocity) #also update the user concern config,one user one concerncargo
    end
    
    if params[:concern_type]=="line" && !@concerncargo.line.blank?
      new_concerncargoline=Array.new 
      new_concerncargoline=@concerncargo.line
   
      (@concerncargo.line.size-1).downto(0).each do |index|      
        all_line_array=get_all_line_array(@concerncargo.line[index][0])
        # log=Logger.new("line.log")
        # log.info "all line_array_size=#{all_line_array.size}"
        all_line_concern=Array.new
        all_line_array.each do |eachline|
          lineconcern= Concernlinec.where(:line=>eachline).first         
          if lineconcern.blank? #initialize the lineconcern
            lineconcern=Concernlinec.new
            lineconcern.line=eachline
            lineconcern.emaillist=Array.new      
            lineconcern.smslist=Array.new   
          end
          all_line_concern<<lineconcern
        end
        if  params["delete#{index}"]    #if delete we dont care about other checkbox  just remove 
          new_concerncargoline.delete_at(index)
          #remove email from city subscribe list
          all_line_concern.each do |lineconcern|
            lineconcern.emaillist.delete(session[:user_email]) #remove email from list if have
            lineconcern.smslist.delete(session[:user_email]) #remove email from list if have
          end
        else #if not check delete
          if params["mail#{index}"]  #checked mail subscribe         
            #delete if unsubscribe from list
            puts "email= #{@concerncargo.line[index][1]}"
            if @concerncargo.line[index][1]==false #not added into yet
              # puts "insert email!"
              all_line_concern.each do |lineconcern|
                lineconcern.emaillist<<session[:user_email]    
              end
            else
              #  puts "already inserted email!"
            end
            new_concerncargoline[index][1]=true #must insert here, seemed will change the @concerncargo also,should refrence
          else
            if @concerncargo.line[index][1]==true #if original is true then we need delete from subscribe list
              #  puts "remove for uncheck"
              all_line_concern.each do |lineconcern|
                lineconcern.emaillist.delete(session[:user_email])    
              end
            else
              #   puts "already deleted "
            end
            new_concerncargoline[index][1]=false
          end
          if params["sms#{index}"] #if checked sms subscribe
         
            if @concerncargo.line[index][2]==false #not added into yet
              all_line_concern.each do |lineconcern|
                lineconcern.smslist<< @user.mobilephone      
              end
            end 
            new_concerncargoline[index][2]=true
          else
            if @concerncargo.line[index][2]==true
              #  puts "remove for uncheck"
              all_line_concern.each do |lineconcern|
                lineconcern.smslist.delete(@user.mobilephone )    
              end
            else
              #   puts "already deleted "
            end
            new_concerncargoline[index][2]=false #we must  set this value at last 
          end
        
        end
        
        #now update subscribe list of city
        all_line_concern.each do |lineconcern|
          #   cityconcern.save! 
          new_email_list=lineconcern.emaillist
          new_sms_list=lineconcern.smslist
          lineconcern.save
          #  cityconcern.update_attribute(:emaillist,nil)
          lineconcern.update_attribute(:emaillist,new_email_list) #we have to do this due to save not fetch array data,only save a empty array
          lineconcern.update_attribute(:smslist,new_sms_list)
        end

      end
      @concerncargo.update_attribute(:line,nil)
      @concerncargo.update_attribute(:line,new_concerncargoline) #also update the user concern config,one user one concerncargo
    end
      

    
    if params[:concern_type]=="user" && !@concerncargo.userid.blank?
      new_concerncargouser=Array.new 
      new_concerncargouser=@concerncargo.userid
      
      (@concerncargo.userid.size-1).downto(0).each do |index|
        userconcern= Concernuserc.where(:userid=>@concerncargo.userid[index][3]).first  
        if  userconcern.blank?
          userconcern=Concernuserc.new
          userconcern.userid=@concerncargo.userid[index][3]
          userconcern.emaillist=[]
          userconcern.smslist=[]
        end
        if  params["delete#{index}"] 
          userconcern.emaillist.delete(session[:user_email])
          userconcern.smslist.delete(@user.mobilephone)
          new_concerncargouser.delete_at(index)    
        else
          if  params["mail#{index}"]  
            if  new_concerncargouser[index][1]==false
              userconcern.emaillist<<session[:user_email]
            end
            new_concerncargouser[index][1]=true
          else
            if  new_concerncargouser[index][1]==true
              userconcern.emaillist.delete(session[:user_email])
            end
            new_concerncargouser[index][1]=false
          end  
        
          if  params["sms#{index}"]  
            if  new_concerncargouser[index][2]==false
              userconcern.smslist<< @user.mobilephone
            end
            new_concerncargouser[index][2]=true
          else
            if  new_concerncargouser[index][2]==true
              userconcern.smslist.delete( @user.mobilephone)
            end
            new_concerncargouser[index][2]=false
          end 
        end
        userconcern.save
        userconcern.update_attribute(:emaillist,userconcern.emaillist) #we have to do this due to save not fetch array data,only save a empty array
        userconcern.update_attribute(:smslist,userconcern.smslist)
      end
      
      #this may be database bug,it could not update directly for element in array
      @concerncargo.update_attribute(:userid,nil)
      @concerncargo.update_attribute(:userid,new_concerncargouser)
    end
    
    
    if params[:concern_type]=="phone" && !@concerncargo.phone.blank?
      new_concerncargophone=Array.new 
      new_concerncargophone=@concerncargo.phone
      
      (@concerncargo.phone.size-1).downto(0).each do |index|
        #phone 1 is mobile
        phoneconcern1= Concernphonec.where(:phone=>@concerncargo.phone[index][0][0]).first  
        #phone 2 is fix mobile phone
        phoneconcern2= Concernphonec.where(:phone=>@concerncargo.phone[index][0][1]).first  unless @concerncargo.phone[index][0][1].blank?
        if  phoneconcern1.blank?  and not @concerncargo.phone[index][0][0].blank?
          phoneconcern1=Concernphonec.new
          phoneconcern1.phone=@concerncargo.phone[index][0][0]
          phoneconcern1.emaillist=[]
          phoneconcern1.smslist=[]
        end
        
        if  phoneconcern2.blank? and not @concerncargo.phone[index][0][1].blank?
          phoneconcern2=Concernphonec.new
          phoneconcern2.phone=@concerncargo.phone[index][0][1]
          phoneconcern2.emaillist=[]
          phoneconcern2.smslist=[]
        end
        if  params["delete#{index}"] 
          phoneconcern1.emaillist.delete(session[:user_email]) if phoneconcern1
          phoneconcern2.emaillist.delete(session[:user_email]) if phoneconcern2
          phoneconcern1.smslist.delete(@user.mobilephone) if phoneconcern1
          phoneconcern2.smslist.delete(@user.mobilephone)  if phoneconcern2
          new_concerncargophone.delete_at(index)  
      
        else
          if  params["mail#{index}"]   
            if @concerncargo.phone[index][1]==false
              phoneconcern1.emaillist<<session[:user_email] if phoneconcern1
              phoneconcern2.emaillist<<session[:user_email]  if phoneconcern2
            end
          
            new_concerncargophone[index][1]=true
          else
            if @concerncargo.phone[index][1]==true
              phoneconcern1.emaillist.delete(session[:user_email]) if phoneconcern1
              phoneconcern2.emaillist.delete(session[:user_email])  if phoneconcern2
            end
            new_concerncargophone[index][1]=false
          end      
          
          if  params["sms#{index}"]   
            if @concerncargo.phone[index][2]==false
              phoneconcern1.smslist<<@user.mobilephone if phoneconcern1
              phoneconcern2.smslist<<@user.mobilephone  if phoneconcern2
            end
          
            new_concerncargophone[index][2]=true
          else
            if @concerncargo.phone[index][2]==true
              phoneconcern1.smslist.delete(@user.mobilephone) if phoneconcern1
              phoneconcern2.smslist.delete(@user.mobilephone)   if phoneconcern2
            end
            new_concerncargophone[index][2]=false
          end   
        end

        if  phoneconcern1
            phoneconcern1.save
        phoneconcern1.update_attribute(:emaillist, phoneconcern1.emaillist) #we have to do this due to save not fetch array data,only save a empty array
        phoneconcern1.update_attribute(:smslist, phoneconcern1.smslist)
        end
        
         if  phoneconcern2
            phoneconcern2.save
        phoneconcern2.update_attribute(:emaillist, phoneconcern1.emaillist) #we have to do this due to save not fetch array data,only save a empty array
        phoneconcern2.update_attribute(:smslist, phoneconcern1.smslist)
        end
        
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
