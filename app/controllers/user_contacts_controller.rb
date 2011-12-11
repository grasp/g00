 # coding: utf-8
class UserContactsController < ApplicationController
  # GET /contact_people
  # GET /contact_people.xml
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
  # layout "public"
  layout :choose_layout
      def choose_layout       
      return 'usercenter' if action_name=="new" || action_name=="edit"|| action_name=="private"
      return 'public'
     end
  
  def index

    ## only do this when in admin user
    #@user_contacts = UserContact.all

    #for logined user, we only show person he created
    @user_contact = UserContact.first(:conditions=>{:user_id=>session[:user_id]})
    user_id=session[:user_id]

   # @company = Company.where("user_id =?",session[:user_id]).first #only one company actully
   
    @inquery_user=Array.new
    @quote_user=Array.new
    @user_contacts=Array.new
    @users=Array.new

    #vendor
    if params[:who]=="vendor"
      
      ExpiredInquery.where(:cargo_user_id =>user_id,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_user<<inquery.truck_user_id
      end      
      Inquery.where(:cargo_user_id =>user_id,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_user<<inquery.truck_user_id
      end
      
      ExpiredQuote.where(:cargo_company_id =>user_id,:status=>"已成交"||"正在成交").each do |quote|
         @quote_user<<quote.truck_user_id
      end
      Quote.where(:cargo_company_id =>user_id,:status=>"已成交"||"正在成交").each do |quote|
        @quote_user<<quote.truck_user_id
      end
    @quote_user.uniq!
    elsif params[:who]=="custermer"
       ExpiredInquery.where(:truck_user_id =>user_id ,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_user<<inquery.cargo_user_id
      end
      Inquery.where(:truck_user_id =>user_id ,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_user<<inquery.cargo_user_id
      end
      ExpiredQuote.where(:truck_user_id =>user_id, :status=>"已成交"||"正在成交").each do |quote|
        @quote_user<<quote.cargo_user_id
      end
      Quote.where(:truck_user_id =>user_id, :status=>"已成交"||"正在成交").each do |quote|
        @quote_user<<quote.cargo_user_id
      end
      @quote_user.uniq!
    else
      #this is for logined user
      @user_contacts = Company.where(:user_id =>session[:user_id]).first #only one company actully
    end

    #calculate users
    @inquery_user.each do |user_id|
      @users<<User.find(user_id)
    end

    @quote_user.each do |user_id|
      @users<<User.find(user_id)
    end

    @users.each do |user|
    @user_contacts<<UserContact.find(user.user_contact_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml =>@user_contact }
    end
  end

  # GET /contact_people/1
  # GET /contact_people/1.xml
  def show
    if params[:user_id]
     @user_contact = UserContact.first(:conditions=>{:user_id=>params[:user_id]})
    else
    @user_contact = UserContact.find(params[:id])
     end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_contact }
    end
  end
    def showf
    if params[:user_id]
     @user_contact = UserContact.first(:conditions=>{:user_id=>params[:user_id]})
    else
    @user_contact = UserContact.find(params[:id])
     end
    respond_to do |format|
      format.html # showf.html.erb
      format.xml  { render :xml => @user_contact }
    end
  end

  # GET /contact_people/new
  # GET /contact_people/new.xml
  def new
    unless session[:user_id]
     flash[:notice]="非法创建，请注册或者登录后添加"
     redirect_to root_path
    end   
    
    #if already exsit , do nothing
   if UserContact.where(:user_id=>session[:user_id]).first.blank?
    @user=User.find(session[:user_id])
    @user_contact = UserContact.new
    @user_contact.email=@user.email
    @user_contact.mobilephone=@user.mobilephone

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_contact }
    end
   else
      @user_contact=UserContact.where(:user_id=>session[:user_id]).first
      respond_to do |format|
        flash[:notice]="用户联系方式已经创建"
        format.html { render :layout=>'public',:action => "show"}
      end
   end
  end

  # GET /contact_people/1/edit
  def edit
    unless params[:id].nil?
          @user_contact= UserContact.find(params[:id])
    else
      @user_contact=UserContact.where(:user_id =>session[:user_id]).first
      if  @user_contact
      @user_contact.name=session[:user_name]
      @user_contact.email=session[:user_email]
    #  @user_contact.group="001"  #what is this for????
      else
        redirect_to :action=>"new"
      end
    end
  end

  # POST /contact_people
  # POST /contact_people.xml
  def create
     params[:usercontact][:user_id]=session[:user_id]
     @user_contact = UserContact.new(params[:usercontact])
     
     @user=User.find(session[:user_id])
     
    if @user.mobilephone!= @user_contact.mobilephone
      @user.update_attribute("mobilephone",@user_contact.mobilephone)
    end
    
    if @user.email!= @user_contact.email && !(@user_contact.email.blank?)
         @user.update_attribute("email",@user_contact.email)
    end

    @user.update_attribute("user_contact_id",@user_contact.id)
 
    respond_to do |format|
      if @user_contact.save
         flash[:notice] = '联系信息创建成功'      
         format.html {  render :layout=>'public',:action => "show" }
      else
        flash[:notice] = '创建联系人失败'
        format.html { render :action => "new",:layout=>"public" }
        format.xml  { render :xml => @user_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_people/1
  # PUT /contact_people/1.xml
  def update
    @user_contact=UserContact.find(params[:id])

    respond_to do |format|
      if @user_contact.update_attributes(params[:usercontact])
        flash[:notice] ="成功更新了联系人#{@user_contact.name}"
        format.html { render :layout=>'public',:action => "show"  }
        format.xml  { head :ok }
      else
         flash[:notice] ="更新联系人失败"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_people/1
  # DELETE /contact_people/1.xml
  def destroy
    @user_contact = UserContact.find(params[:id])
    @user_contact.destroy

    respond_to do |format|
      format.html { redirect_to(contact_people_url) }
      format.xml  { head :ok }
    end
  end
  
  def private
     @user_contact = UserContact.where(:user_id=>session[:user_id]).first
  end
end
