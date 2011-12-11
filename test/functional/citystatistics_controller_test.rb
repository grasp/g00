require 'test_helper'

class CitystatisticsControllerTest < ActionController::TestCase
  setup do
    @citystatistic = citystatistics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:citystatistics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create citystatistic" do
    assert_difference('Citystatistic.count') do
      post :create, :citystatistic => @citystatistic.attributes
    end

    assert_redirected_to citystatistic_path(assigns(:citystatistic))
  end

  test "should show citystatistic" do
    get :show, :id => @citystatistic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @citystatistic.to_param
    assert_response :success
  end

  test "should update citystatistic" do
    put :update, :id => @citystatistic.to_param, :citystatistic => @citystatistic.attributes
    assert_redirected_to citystatistic_path(assigns(:citystatistic))
  end

  test "should destroy citystatistic" do
    assert_difference('Citystatistic.count', -1) do
      delete :destroy, :id => @citystatistic.to_param
    end

    assert_redirected_to citystatistics_path
  end
end
