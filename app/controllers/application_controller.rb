 # coding: utf-8
class ApplicationController < ActionController::Base
   before_filter :prepare_for_mobile
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
     helper_method :mobile_device?


   def get_line(from_code,to_code)     
    if from_code<to_code
      return from_code+to_code
    elsif from_code>to_code
      return to_code+from_code
    else
      return from_code+to_code
   end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private
  def admin_authorize
     unless  session[:user_name]=="admin"
        flash[:notice]="只有管理员才能操作"
       redirect_to root_path
     end
  end

  def authorize    
     return if session[:user_id] #if already authorized
     #coockie login
      unless cookies.signed[:remember_me].blank?
       #find cookie and check cookie password
        logger.debug "cookies.signed[:preference]=#{cookies.signed[:remember_me][2]}"
        logger.debug "cookies.signed[:remember_me]=#{cookies.signed[:remember_me]}"
      if(cookies.signed[:remember_me][2]==1)
       @user = User.authenticated_with_token(cookies.signed[:remember_me][0],cookies.signed[:remember_me][1])
       if @user.blank?
         redirect_to userslogin_path
       else
         session[:user_id]=@user.id
         session[:user_name]=@user.name
         session[:user_email]=@user.email
         session[:original_uri]=nil
       end
      else
         redirect_to userslogin_path
     end
     return  #allowed cookie login
     end
     
    #now only we can do is redirect
       logger.debug "session not exsist"
       flash[:notice]="请您先登录"
       logger.debug "request url=#{request.path},root_path=#{root_path}"
       redirect_to userslogin_path
     end

  #without redirect
   def authorize_public
     return if session[:user_id] #if already authorized
     #coockie login
      unless cookies.signed[:remember_me].blank?
       #find cookie and check cookie password
        logger.debug "cookies.signed[:preference]=#{cookies.signed[:remember_me][2]}"
        logger.debug "cookies.signed[:remember_me]=#{cookies.signed[:remember_me]}"
      if(cookies.signed[:remember_me][2]==1)
       @user = User.authenticated_with_token(cookies.signed[:remember_me][0],cookies.signed[:remember_me][1])
       if @user.blank?
         redirect_to root_path
       else
         session[:user_id]=@user.id
         session[:user_name]=@user.name
         session[:user_email]=@user.email
         session[:original_uri]=nil
       end
     end
     return  #allowed cookie login
     end
  end
  


#private

def mobile_device?
  if session[:mobile_param]
    session[:mobile_param] == "1"
  else
    request.user_agent =~ /Mobile|webOS|iPhone/ 
  end  
end

def prepare_for_mobile
  session[:mobile_param] = params[:mobile] if params[:mobile]  
 # request.format=:mobile  if mobile_device?
 # request.format=[:mobile,:html] if mobile_device?
# self.formats[:mobile,:html]
# request.formats.unshift(Mime::MOBILE) if mobile_device?
end
end
