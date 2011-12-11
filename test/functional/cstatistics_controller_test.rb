require 'test_helper'

class CstatisticsControllerTest < ActionController::TestCase
  setup do
    @cstatistic = cstatistics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cstatistics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cstatistic" do
    assert_difference('Cstatistic.count') do
      post :create, :cstatistic => @cstatistic.attributes
    end

    assert_redirected_to cstatistic_path(assigns(:cstatistic))
  end

  test "should show cstatistic" do
    get :show, :id => @cstatistic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cstatistic.to_param
    assert_response :success
  end

  test "should update cstatistic" do
    put :update, :id => @cstatistic.to_param, :cstatistic => @cstatistic.attributes
    assert_redirected_to cstatistic_path(assigns(:cstatistic))
  end

  test "should destroy cstatistic" do
    assert_difference('Cstatistic.count', -1) do
      delete :destroy, :id => @cstatistic.to_param
    end

    assert_redirected_to cstatistics_path
  end
end
