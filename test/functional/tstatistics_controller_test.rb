require 'test_helper'

class TstatisticsControllerTest < ActionController::TestCase
  setup do
    @tstatistic = tstatistics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tstatistics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tstatistic" do
    assert_difference('Tstatistic.count') do
      post :create, :tstatistic => @tstatistic.attributes
    end

    assert_redirected_to tstatistic_path(assigns(:tstatistic))
  end

  test "should show tstatistic" do
    get :show, :id => @tstatistic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tstatistic.to_param
    assert_response :success
  end

  test "should update tstatistic" do
    put :update, :id => @tstatistic.to_param, :tstatistic => @tstatistic.attributes
    assert_redirected_to tstatistic_path(assigns(:tstatistic))
  end

  test "should destroy tstatistic" do
    assert_difference('Tstatistic.count', -1) do
      delete :destroy, :id => @tstatistic.to_param
    end

    assert_redirected_to tstatistics_path
  end
end
