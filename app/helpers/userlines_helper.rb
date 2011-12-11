module UserlinesHelper
  
 def get_province_userlines_from_count(province)
 next_province=province+10000000000
return Userline.where(:fcityid.gte=>province.to_s,:fcityid.lt=> next_province.to_s).count
 end

  def get_province_userlines_to_count(province)
 next_province=province+10000000000
return Userline.where(:tcityid.gte=>province.to_s,:tcityid.lt=> next_province.to_s).count
 end


 def get_region_userlines_from_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Userline.where(:fcityid.gte=>regioncity.to_s,:fcityid.lt=> next_region.to_s).count
 end
 def get_region_userlines_to_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Userline.where(:tcityid.gte=>regioncity.to_s,:tcityid.lt=> next_region.to_s).count
 end
  
end
