require 'test_helper'

class UstatisticsControllerTest < ActionController::TestCase
  setup do
    @ustatistic = ustatistics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ustatistics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ustatistic" do
    assert_difference('Ustatistic.count') do
      post :create, :ustatistic => @ustatistic.attributes
    end

    assert_redirected_to ustatistic_path(assigns(:ustatistic))
  end

  test "should show ustatistic" do
    get :show, :id => @ustatistic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ustatistic.to_param
    assert_response :success
  end

  test "should update ustatistic" do
    put :update, :id => @ustatistic.to_param, :ustatistic => @ustatistic.attributes
    assert_redirected_to ustatistic_path(assigns(:ustatistic))
  end

  test "should destroy ustatistic" do
    assert_difference('Ustatistic.count', -1) do
      delete :destroy, :id => @ustatistic.to_param
    end

    assert_redirected_to ustatistics_path
  end
end
