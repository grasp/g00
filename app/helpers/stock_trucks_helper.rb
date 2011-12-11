 # coding: utf-8
module StockTrucksHelper
  def get_stock_truck_from_params(params)

   # stock_truck_hash=Hash.new
   # stock_truck_hash[:paizhao]=params[:paizhao]
     #stock_truck_hash[:car_phone]=params[:car_phone]
    # stock_truck_hash[:che_length]=params[:che_length]
   #  stock_truck_hash[:dun_wei]=params[:dun_wei]

   #  stock_truck_hash[:contact_person_id]=params[:contact].to_i
  #   stock_truck_hash[:company_id]=params[:company].to_i
  #   stock_truck_hash[:truck_usage]=params[:truck_usage]
   #  stock_truck_hash[:truck_shape]=params[:truck_shape]
   #  stock_truck_hash[:truck_gps]=params[:truck_gps]

   #  stock_truck_hash[:truck_year]=params[:truck_year]
   #  stock_truck_hash[:truck_pinpai]=params[:truck_pinpai]
   #  stock_truck_hash[:truck_xinghao]=params[:truck_xinghao]


   # @user_id=session[:user_id]
   # @user_name=session[:user_id]
  #  params[:stock_truck][:user_id]=@user_id

     #add company
#    @stock_truck = StockTruck.create!(params[:stock_truck])

 #   if  @stock_truck
 #     puts "success created"
  #    return true
  #  else

  #    return false
  #  end
  end

  def update_stock_truck_from_params(params)

    if   @stock_truck
      @stock_truck.update_attributes(params[:stock_truck])
      return @stock_truck
    end

  end
end
