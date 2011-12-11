require 'test_helper'

class JubaosControllerTest < ActionController::TestCase
  setup do
    @jubao = jubaos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jubaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create jubao" do
    assert_difference('Jubao.count') do
      post :create, :jubao => @jubao.attributes
    end

    assert_redirected_to jubao_path(assigns(:jubao))
  end

  test "should show jubao" do
    get :show, :id => @jubao.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @jubao.to_param
    assert_response :success
  end

  test "should update jubao" do
    put :update, :id => @jubao.to_param, :jubao => @jubao.attributes
    assert_redirected_to jubao_path(assigns(:jubao))
  end

  test "should destroy jubao" do
    assert_difference('Jubao.count', -1) do
      delete :destroy, :id => @jubao.to_param
    end

    assert_redirected_to jubaos_path
  end
end
