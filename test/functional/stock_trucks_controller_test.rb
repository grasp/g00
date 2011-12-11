require 'test_helper'

class StockTrucksControllerTest < ActionController::TestCase
  setup do
    @stock_truck = stock_trucks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_trucks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_truck" do
    assert_difference('StockTruck.count') do
      post :create, :stock_truck => @stock_truck.attributes
    end

    assert_redirected_to stock_truck_path(assigns(:stock_truck))
  end

  test "should show stock_truck" do
    get :show, :id => @stock_truck.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_truck.to_param
    assert_response :success
  end

  test "should update stock_truck" do
    put :update, :id => @stock_truck.to_param, :stock_truck => @stock_truck.attributes
    assert_redirected_to stock_truck_path(assigns(:stock_truck))
  end

  test "should destroy stock_truck" do
    assert_difference('StockTruck.count', -1) do
      delete :destroy, :id => @stock_truck.to_param
    end

    assert_redirected_to stock_trucks_path
  end
end
