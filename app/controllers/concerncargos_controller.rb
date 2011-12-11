#coding:utf-8
class ConcerncargosController < ApplicationController
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
    else
      session[:original_url]=request.url
      redirect_to userslogin_path,:flash=>{:notice=>" 注册用户才能添加关注，花费数秒钟免费注册下，从此尽可享受免费的精彩服务"}
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
          @concerncargo.city<<[params[:citycode],false,false]    
          @concerncargo.city.uniq!      
        end
        
        if params[:concern_type]=="line" 
          #check unique for user?
          @concerncargo.line= Array.new   if  @concerncargo.line.blank?  
          @concerncargo.line<<[params[:fcitycode]+"#"+params[:tcitycode],false,false]    
          @concerncargo.line.uniq!      
        end
        
        if params[:concern_type]=="user" 
          #check unique for user?
          @concerncargo.userid= Array.new   if  @concerncargo.userid.blank?  
          @concerncargo.userid<<[params[:username],false,false]   #false, false, means mail and sms subscribe is not
          @concerncargo.userid.uniq!      
        end
        
        if params[:concern_type]=="phone" 
          #check unique for user?
          @concerncargo.phone= Array.new   if  @concerncargo.phone.blank?  
          @concerncargo.phone<<[[params[:mobilephone],params[:fixphone],params[:email],params[:QQ],params[:comments]],false,false]
          @concerncargo.phone.uniq!      
        end
        
      end
    end
    respond_to do |format|
      if @concerncargo.save
        flash[:notice]="成功添加关注!"
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
          puts "delete#{index}="+params["delete#{index}"] 
          @concerncargo.city.delete_at(index)
        end
      end
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
      format.html { redirect_to concerncargosuserconcern_path}
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
      format.html { redirect_to(concerncargos_url) }
      format.xml  { head :ok }
    end
  end
end
