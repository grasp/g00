require 'test_helper'

class LstatisticsControllerTest < ActionController::TestCase
  setup do
    @lstatistic = lstatistics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lstatistics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lstatistic" do
    assert_difference('Lstatistic.count') do
      post :create, :lstatistic => @lstatistic.attributes
    end

    assert_redirected_to lstatistic_path(assigns(:lstatistic))
  end

  test "should show lstatistic" do
    get :show, :id => @lstatistic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @lstatistic.to_param
    assert_response :success
  end

  test "should update lstatistic" do
    put :update, :id => @lstatistic.to_param, :lstatistic => @lstatistic.attributes
    assert_redirected_to lstatistic_path(assigns(:lstatistic))
  end

  test "should destroy lstatistic" do
    assert_difference('Lstatistic.count', -1) do
      delete :destroy, :id => @lstatistic.to_param
    end

    assert_redirected_to lstatistics_path
  end
end
