
#if true
@admin=User.where(:name=>"admin").first

if @admin.blank?
  puts "prepare to create admin"
  @admin=User.new
  salt= @admin.object_id.to_s+rand.to_s
  password="grasp56#"
  hashed_password=User.encrypted_password(password, salt)
  @admin.name="admin"
  @admin.admin="true"
  @admin.salt=salt
  @admin.hashed_password=hashed_password
  @admin.mobilephone="15967126712"
  @admin.status="activated"
  @admin.email="w22812@mot.com"
 if @admin.save
  Rails.logger.info "create admin succ"
 else
 Rails.logger.info  "create admin fail"
 raise
 end
  Rails.logger.info  "  hashed_password=#{  hashed_password},salt=#{salt},password=#{password}"
 # ustatistic=Ustatistic.create(:total_stock_cargo=>0,:total_stock_truck=>0,:total_truck=>0,
  #        :total_cargo=>0,:total_line=>0, :total_driver=>0,:total_custermer=>0,:valid_cargo=>0,
 #         :valid_truck=>0,:user_id=>@admin.id);
 # @admin.update_attributes("ustatistic_id"=>ustatistic.id)
else
 Rails.logger.info  "admin alread created"
end
#end

#initialize sitdata

if Sitedatum.first.blank?
  Sitedatum.create(:ie6=>0,:ie7=>0,:ie8=>0,:noneie=>0)
end

@first_announce=Announce.first
#City.delete_all
#initialize Cities
if City.count==0
  $city_code_name.each do |code,name|
    City.create(:code=>code,:name=>name)
  end
end