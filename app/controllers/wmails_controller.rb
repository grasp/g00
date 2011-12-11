#coding:utf-8
class WmailsController < ApplicationController
  # GET /wmails
  # GET /wmails.xml
  layout "admin"
  layout :choose_layout 
  
  before_filter:authorize  
   
  def choose_layout
    return 'admin'  if action_name =='index' || action_name =='new'
    return  'public' if  action_name=="invite_new"||action_name=="show"
    return  nil 

  end
  def index
    if session[:user_name]=="admin"
      @wmails = Wmail.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wmails }
    end
  end

  # GET /wmails/1
  # GET /wmails/1.xml
  def show
    @wmail = Wmail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wmail }
    end
  end

  # GET /wmails/new
  # GET /wmails/new.xml
  def new
    @wmail = Wmail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wmail }
    end
  end

  # GET /wmails/1/edit
  def edit
    @wmail = Wmail.find(params[:id])
  end

  # POST /wmails
  # POST /wmails.xml
  def create
    params[:wmail][:fromu]=session[:user_id]
    @wmail = Wmail.new(params[:wmail])
    @user=User.find(session[:user_id])
    #now we will try send out a email here
    if params[:wmail][:mailtype]=="invite"
      Notifier.send_invite_mail(params[:wmail][:to].split(";"),params[:wmail][:subject],@user).deliver!    
    else
      Notifier.send_email(params[:wmail][:to],params[:wmail][:subject],params[:wmail][:body]).deliver!    
    end
    
    respond_to do |format|
      if @wmail.save
        format.html { redirect_to(@wmail, :notice => '邮件发送成功！.') }
        format.xml  { render :xml => @wmail, :status => :created, :location => @wmail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wmail.errors, :status => :unprocessable_entity }
      end
    end
  end
  def create_multiemail
     @user=User.find(session[:user_id])
     @today_total=Wmail.where(:from=>@user.email,:created_at.gte=>Time.now.at_beginning_of_day).count
    params[:wmail][:fromu]=session[:user_id]
    @wmail = Wmail.new(params[:wmail])
    @user=User.find(session[:user_id])
    #now we will try send out a email here
     if ((session[:user_id] && @today_total<=10) || @user.email=="mark.xiansheng@gmail.com" )
      begin
        Notifier.send_invite_mail(params[:wmail][:to].split(";"),params[:wmail][:subject],@user).deliver!    
        @result="发送成功,今日已发送#{@today_total+1}/10"
        @wmail.save
      rescue
        @result="发送失败,今日已发送#{@today_total}/10"
      end
     else
        @result="无效发送,今日已发送#{@today_total}/10"
     end
    
  end
  

  # PUT /wmails/1
  # PUT /wmails/1.xml
  def update
    @wmail = Wmail.find(params[:id])

    respond_to do |format|
      if @wmail.update_attributes(params[:wmail])
        format.html { redirect_to(@wmail, :notice => 'Wmail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wmail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wmails/1
  # DELETE /wmails/1.xml
  def destroy
    if session[:user_name]=="admin"
      @wmail = Wmail.find(params[:id])
      @wmail.destroy
    end

    respond_to do |format|
      format.html { redirect_to(wmails_url) }
      format.xml  { head :ok }
    end
  end
  
  def invite_new
    @wmail=Wmail.new
    @wmail.mailtype="invite"
    @subject="您的一个朋友#{session[:user_name]}邀请您访问物流零距离网站-w090.com"  
  end
  

  
  def new_send_cargo_friend_mail
    
  end
  
  
end
