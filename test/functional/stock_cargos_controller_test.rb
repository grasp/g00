require 'test_helper'

class StockCargosControllerTest < ActionController::TestCase
  setup do
    @stock_cargo = stock_cargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_cargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_cargo" do
    assert_difference('StockCargo.count') do
      post :create, :stock_cargo => @stock_cargo.attributes
    end

    assert_redirected_to stock_cargo_path(assigns(:stock_cargo))
  end

  test "should show stock_cargo" do
    get :show, :id => @stock_cargo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_cargo.to_param
    assert_response :success
  end

  test "should update stock_cargo" do
    put :update, :id => @stock_cargo.to_param, :stock_cargo => @stock_cargo.attributes
    assert_redirected_to stock_cargo_path(assigns(:stock_cargo))
  end

  test "should destroy stock_cargo" do
    assert_difference('StockCargo.count', -1) do
      delete :destroy, :id => @stock_cargo.to_param
    end

    assert_redirected_to stock_cargos_path
  end
end
