#coding:utf-8
module PlanSettingsHelper
  
  def init_plan_setting
    @product=["W090","Android","Caiji","KD090"]       
    @product_fa_tie={"W090"=>["TopIssue","概要需求","概要设计","年度计划","月度计划","首页设计","货物管理","货源管理","车辆管理","定位管理","车源管理","用户管理","公司管理","专线管理","缓存管理","在线支付","广告管理","物信宝服务","帮助中心","访问统计","手机订阅"],
                      "Android"=>["TopIssue","概要需求","概要设计","年度计划","月度计划","W090","GPS","HttpClient","GUI"],
                      "Caiji"=>["TopIssue","概要需求","概要设计","年度计划","月度计划","货源","车源","联系方式","搜索引擎"],
                       "KD090"=>["TopIssue","概要需求","概要设计","年度计划"]
                     }

    @thirdparty={"W090"=>["Ubuntu","Ruby","Rails","CSS","Mongodb","Mongoid","Redis","Redis-store","JavaScript","Bootstrap","ckeditor"],
       "Android"=>["Activity","Service","Intent","Manefiest","Resource","Simulator","Debug","GPSLogger"]
    }    
    @user=["hunter","steven"]
    @product.each do |product|
 unless @product_fa_tie[product].nil?
      @product_fa_tie[product].each do |fa|
        PlanSetting.create(:system=>product,:fa=>fa,:branch=>"FA",:status=>"enabled",:creater=>"hunter",:contributor=>["hunter"])
      end
 end
      unless  @thirdparty[product].nil?
      @thirdparty[product].each do |thirpard|
        PlanSetting.create(:system=>product,:fa=>thirpard,:branch=>"Thirdparty",:status=>"enabled",:creater=>"hunter",:contributor=>["hunter"])
      end
      end
    end  
    
    get_all_system
  end
  
  def get_all_system
    $plan_system= Array.new
    PlanSetting.all.each do |setting|
      unless setting.system.nil?
      $plan_system<<setting.system unless $plan_system.include?(setting.system) 
      end
    end
    return $plan_system
  end
  
  def get_all_branch(system)
    branch= Array.new
        PlanSetting.where(:system=>system,:status=>"enabled").each do |setting|          
          branch << setting.branch unless branch.include?(setting.branch)
          end          
    return   branch
    end

  
  def get_all_fa(system,branch)
    fa=Array.new
    PlanSetting.where(:system=>system,:branch=>branch,:status=>"enabled").each do |setting|
      puts "setting.fa=#{setting.fa}"
      fa << setting.fa unless fa.include?(setting.fa)
    end
    return fa
  end
end
