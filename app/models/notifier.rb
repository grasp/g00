#coding:utf-8
  
class Notifier < ActionMailer::Base
  default :from => "w090.master@w090.com"

  # send a signup email to the user, pass in the user object that contains the user's email address
  def send_signup_email(user)
    @user=user
    mail( 
      :from=>"w090.master@w090.com",
      :to => user.email, 
      :subject => "物流零距离-感谢您的注册，请点击以下链接确认你的邮箱",
      :template_path => 'users',
      :template_name => 'signup')
  end

  def send_pw_forget(user)
    @user=user
    mail( 
      :from=>"w090.master@w090.com",
      :to => user.email, 
      :subject => "来自物流零距离管理员，请点击以下链接重置您的密码",
      :template_path => 'users',
      :template_name => 'pw_forget')
  end
  # send a signup email to the user, pass in the user object that contains the user's email address

  
  def send_invite_mail(to,subject,user)
    @user=user
    mail( 
      :from=>user.email,
      :to => to,
      :subject => subject,
      :template_path => 'wmails',
      :template_name => 'invite_mail')
  end
  
  def send_cargo_myself(user,cargo,contact)
    @user=user
    @cargo=cargo
    @contact=contact
    mail( 
      :to => user.email,
      :subject => "物流零距离货源信息-#{@cargo.fcity_name}-#{@cargo.tcity_name}- #{@cargo.cate_name ||'未知货物'}-#{@cargo.cargo_weight || '0 吨'}-#{@cargo.cargo_bulk ||'0 方' }",
      :template_path => 'cargos',
      :template_name => 'send_cargo_myself_mail')
  end

  def send_cargo_friend(user,cargo,contact,to)
    @user=user
    @cargo=cargo
    @contact=contact
    mail( 
      :to => to,
      :subject => "物流零距离货源信息-#{@cargo.fcity_name}-#{@cargo.tcity_name}- #{@cargo.cate_name ||'未知货物'}-#{@cargo.cargo_weight || '0 吨'}-#{@cargo.cargo_bulk ||'0 方' }",
      :template_path => 'cargos',
      :template_name => 'send_cargo_myself_mail')
  end

  def send_site_update_to_register(user)
    @user=user
    mail( 
      :to => user.email,
      :subject => "物流零距离网站有更新了，更多货源和车源了，访问速度更快了",
      :template_path => 'users',
      :template_name => 'site_update_email')
  end

  
  def send_notify_email(email,project_root)
    puts "start send_notify_email "
    @user=User.where(:email=>email.email).first
    @cargos=Array.new
    email.cargolist.each do |cargoid|
      begin
        @cargos<<Cargo.find(cargoid)
      rescue
        puts "could not find cargo id #{cargoid}"
      end
    end
  #  puts "cargo size=#{@cargos.size},tempate path=#{project_root}/app/views/concerncargos"
  title= $city_code_name[@cargos[0].fcity_code]+"到"+$city_code_name[@cargos[0].tcity_code]+ (@cargos[0].cargo_weight || "0") +"吨/"+(@cargos[0].cargo_bulk ||0).to_s+"方"

    project_root="/opt/vob/g00"
    mail( :to => email.email, 
      :charset => "UTF-8",
      :from=>"w090.master@gmail.com",
     #:subject => "关注的货源信息#{Time.now.to_s.slice(0,19)}",
      :subject =>title)do |format|
      format.html{render "#{project_root}/app/views/concerncargos/concern_mail"}
    end
     # :template_path => "#{project_root}/app/views/concerncargos",
    #  :template_name => "concern_mail")

  end
  
  def send_email(to,subject,body)
    mail( :to => to, 
      :subject => subject,
      :body=>body )
  end
end