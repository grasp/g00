 # coding: utf-8
module StockCargosHelper

  def get_cate_name
    if @stock_cargo.cate_name.nil?
    return "类别选择"
    else      
   return @stock_cargo.cate_name
    end
  end

  def get_cate_code
    if @stock_cargo.cate_code.nil?
    return "040000"
    else      
   return @stock_cargo.cate_code
    end
  end

  def get_package_name
    if @stock_cargo.package_name.nil?
    return "包装选择"
    else
    return @stock_cargo.package_name
    end
  end
    def get_package_code
    if @stock_cargo.package_code.nil?
    return "1000"
    else
    return @stock_cargo.package_code
    end
  end
  
end
