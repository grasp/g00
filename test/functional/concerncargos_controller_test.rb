require 'test_helper'

class ConcerncargosControllerTest < ActionController::TestCase
  setup do
    @concerncargo = concerncargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:concerncargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create concerncargo" do
    assert_difference('Concerncargo.count') do
      post :create, :concerncargo => @concerncargo.attributes
    end

    assert_redirected_to concerncargo_path(assigns(:concerncargo))
  end

  test "should show concerncargo" do
    get :show, :id => @concerncargo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @concerncargo.to_param
    assert_response :success
  end

  test "should update concerncargo" do
    put :update, :id => @concerncargo.to_param, :concerncargo => @concerncargo.attributes
    assert_redirected_to concerncargo_path(assigns(:concerncargo))
  end

  test "should destroy concerncargo" do
    assert_difference('Concerncargo.count', -1) do
      delete :destroy, :id => @concerncargo.to_param
    end

    assert_redirected_to concerncargos_path
  end
end
