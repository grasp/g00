require 'test_helper'

class UserlinesControllerTest < ActionController::TestCase
  setup do
    @userline = userlines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:userlines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create userline" do
    assert_difference('Userline.count') do
      post :create, :userline => @userline.attributes
    end

    assert_redirected_to userline_path(assigns(:userline))
  end

  test "should show userline" do
    get :show, :id => @userline.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @userline.to_param
    assert_response :success
  end

  test "should update userline" do
    put :update, :id => @userline.to_param, :userline => @userline.attributes
    assert_redirected_to userline_path(assigns(:userline))
  end

  test "should destroy userline" do
    assert_difference('Userline.count', -1) do
      delete :destroy, :id => @userline.to_param
    end

    assert_redirected_to userlines_path
  end
end
