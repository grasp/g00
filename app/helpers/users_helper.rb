# coding: utf-8
module UsersHelper
  def users_center_helper
    @cargos=Cargo.where(:status=>"正在配车",:user_id=>@user.id).desc(:created_at).limit(10)
    @trucks=Truck.where(:status=>"正在配货",:user_id=>@user.id).desc(:created_at).limit(10)
    @company=Company.where(:user_id=>@user.id).first #only one company actully
  end
  
  def cookie_login_helper
    if session[:cookie_logined]!=true
      kookie=cookies.signed[:remember_me]
      if kookie #only when user set cookie login
        return if kookie[2]==0 #do nothing if not set remember me preference
 
      @user=User.authenticated_with_token(kookie[0],kookie[1])
      unless @user.blank?
        session[:user_id]=@user.id  #BSon to string??,no
        session[:user_name]=@user.name
        session[:user_email]=@user.email
        session[:original_uri]=nil##?? should we keep original url?
      end
    end
    end
    session[:cookie_logined]=true     
  end

end
