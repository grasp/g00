# To change this template, choose Tools | Templates
# and open the template in the editor.


ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'your.host.name',
  :user_name            => 'hunter.wxhu',
  :password             => '11102008',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
