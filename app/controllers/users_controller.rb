# coding: utf-8
class UsersController < ApplicationController

  include UsersHelper
  # GET /users
  # GET /users.xml
  #include UsersHelper
   before_filter:admin_authorize,:only=>[:index,:destroy] #for debug purpose
   layout :choose_layout  
  
   # layout 'users'
   # layout :choose_layout
  
  def choose_layout
    return 'admin'  if action_name =='index'      
 #   return 'users' if action_name=="new" || action_name=="edit"
    return 'public' if action_name=="download_spec" ||action_name=="download_setup"
    return "usercenter" if action_name=="center"
    return 'users'
  end


  def index    
    @users = User.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
    
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id]) #is this work?
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new

    @user = User.new(params[:user])
    @user.activate=rand(Time.now.to_i+100000000000).to_s
    @user.status="new_register"
    
    respond_to do |format|
      if @user.save
         #send  activation mail here
         # record the session for authorize
         session[:user_id]=@user.id
         @ustatistic=Ustatistic.create(:total_stock_cargo=>0,:total_stock_truck=>0,:total_truck=>0,
          :total_cargo=>0,:total_line=>0, :total_driver=>0,:total_custermer=>0,:valid_cargo=>0,
          :valid_truck=>0,:user_id=>@user.id,:user_email=>@user.email,:user_name=>@user.name);
        
        #update statistic for user
        @user.update_attribute("ustatistic_id",@ustatistic.id) #it is not attributesSS
if Rails.env.production?

         begin                                
         Notifier.send_signup_email(@user).deliver!
          flash[:notice] = "恭喜您,#{@user.name} 注册成功了！请到你的邮箱点击确认链接，以便我们知道你的邮箱是存在的。邮箱是手机物流信息和及时物流信息通知的基础设施，我们不会发任何垃圾信息和骚扰信息给您"
        rescue
          flash[:notice] = '注册确认邮件发送失败了，如果您使用的是正确的邮箱，我们会马上解决的，现在您可以先使用网站的功能。'
          #record to admin for observe
        end
end
        session[:user_id]=@user.id  #BSon to string??,no
        session[:user_name]=@user.name
        session[:user_email]=@user.email
#this is supposed to direct to original url
      format.html { redirect_to root_path,:flash=>{:notice=>flash[:notice]}}
      else
        if User.first(:conditions=>{:email=>params[:email]})
          flash[:notice] = '该email已经被注册了，确认您不是重复注册，试试用邮箱登录。'
        else
          flash[:notice] = '用户名验证出错，可能用户名已经被注册了'
        end
        
        format.html { render :action => "new" }
        #   format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def resend_activate_code
    if  session[:user_id]
    @user=User.find(session[:user_id])
        begin                                
         Notifier.send_signup_email(@user).deliver!
          flash[:notice] = "激活邮件已经重发,请到你的邮箱点击确认链接，以便我们知道你的邮箱是存在的。邮箱是手机物流信息和及时物流信息通知的基础设施，我们不会发任何垃圾信息和骚扰信息给您"
        rescue
          flash[:notice] = '激活邮件发送失败了，如果您使用的是正确的邮箱，我们会马上解决的，现在您可以先使用网站的功能。'
          #record to admin for observe
        end
    end
  end
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  def login
    @user = User.new
  end

  def pw_reset_request

  end

  def pwreset
    @user=User.first(:conditions=>{:name=>params[:username]})    
    #get the user from the hash
    if  params[:password] !=  params[:password_confirmation]
      flash[:notice] = "确认密码不对，请重新输入 "
    end

    #update the password here
    @user.password=params[:password]
    flash[:notice] = "密码修改成功，请登录"   if  @user.save

    respond_to do |format|

      #redirect to login if not actived,even authenticate is pass
      format.html { redirect_to(:action=>"login") }
    end
  end


  def pw_sent_confirm
  
  @user=User.where(:email=>params[:email]).first
  
  unless @user.blank?
        @user.update_attributes(:activate=>rand(Time.now.to_i+10000000000).to_s)
        @user.update_attributes(:status=>"forgot-password")
    begin
    Notifier.send_pw_forget(@user).deliver!
      flash[:notice] = "密码重置邮件已经发出,请到您的邮箱接收，并点击链接重置密码 "
    rescue
     flash[:notice] = "密码重置邮件发送失败，我们会马上解决 "     
        #warn the admin here
    end
   
  else
    @error="邮箱不存在"
  end
      
      respond_to do |format|
        #redirect to login if not actived,even authenticate is pass
        format.html { redirect_to :action=>"login",:flash=>{:notice=>flash[:notice]}}
      end
  end

  def  change_password_confirm
       @user=User.where(:activate=>params[:activate]).first
    # need check the code of activate field from the
    respond_to do |format|
      if  @user.activate!= params[:activate]
        flash[:notice] = "密码重置链接无效,重置密码失败"
        format.html { redirect_to :action =>"login" ,:flash=>{:notice=>flash[:notice]}}
        format.xml  { head :ok }
      else
        format.html # index.html.erb
        format.xml
      end
    end
  end
  def authenticate
    session[:user_id]= nil
    result=User.authenticate( params[:email],params[:password])
    @user=result[0]
    if @user
        #user login succ, update last login time
        last_login=@user.last_login
        if last_login
          if Time.now-last_login >86400 #if login after one day, generate new data for each user
          expire_fragment  "users_center_#{@user.id}"
          end
        end
        @user.update_attribute("last_login",Time.now) unless @user.name=="admin"        
    end
    #authenticate with cookie
    
    if params[:remember_me]=="on" && @user
      @user.update_attributes(:preference=>1)
      #need store user_info into coockie
      cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,1]   
      
    elsif params[:remember_me]=="off" && @user
       @user.update_attributes(:preference=>0)
       cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,0]
    end

    respond_to do |format|
      # if @user.nil? || @user.status !="actived"
      if @user.nil?
         flash[:notice]="登录失败:#{result[1]}"
         format.html { redirect_to(:controller=>'users',:action=>"login")}
      else
       
        if @user.status =="new_register" 
          flash[:notice] = "请到你的邮箱#{@user.email}去确认邮箱，老用户请到用户中心，可以重新发送激活邮件" 
        end
        session[:user_id]=@user.id  #BSon to string??,no
        session[:user_name]=@user.name
        session[:user_email]=@user.email
  
        #  format.html { redirect_to({:controller=>"cargos",:action => "public"})}
        unless session[:original_url]
        format.html { redirect_to root_path,:flash=>{:notice=>flash[:notice]}}
        else
        format.html { redirect_to session[:original_url],:flash=>{:notice=>flash[:notice]}}
        end
      end
    end
  end

  def activate
    code=params[:code]
    
    @user=User.where(:activate=>params[:code]).first
    
    if (code==@user.activate)
      #@user.status="actived"
      @user.update_attribute("activate","verified")
      flash[:notice] = "用户邮箱确认成功"
      respond_to do |format|
        format.html { redirect_to root_path,:flash=>{:notice=>flash[:notice]}}
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "用户激活码无效"
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def logout   
    begin
     @user=User.find(session[:user_id])  if session[:user_id]
    rescue #incase one of admin was delete
    end
    # reset_session #maybe cause too slow?
        session[:user_id]=nil  #BSon to string??,no
        session[:user_name]=nil
        session[:user_email]=nil
        session[:original_uri]=nil
if @user
     #authenticate with cookie
     @user.update_attribute("preference","0")
     cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,0]
        session[:user_id]=nil  #BSon to string??,no
        session[:user_name]=nil
        session[:user_email]=nil
        session[:original_uri]=nil
end
    respond_to do |format|
      format.html { redirect_to("/") }
    end
  end
  
  def mianze
    
  end
  
  def contact
    
  end
  
  def about
    
  end
  
  def download_spec
    
  end
  
  def download_setup
      setup_file=File.join(Rails.root,"public","setup","setup.exe")
      send_file setup_file, :type=>"application/exe"
  end

  def center
        @mycompany=Company.where(:user_id=>session[:user_id]).first
         @user=User.find(session[:user_id]) unless session[:user_id].nil?
    unless session[:user_id]
      session[:original_url]=request.url
       redirect_to userslogin_path,:flash=>{:notice=>"用户中心可以发布各类信息，需要先登录才能使用，新用户请先注册，谢谢！"}
    end
  end
end

