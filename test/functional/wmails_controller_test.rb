require 'test_helper'

class WmailsControllerTest < ActionController::TestCase
  setup do
    @wmail = wmails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wmails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wmail" do
    assert_difference('Wmail.count') do
      post :create, :wmail => @wmail.attributes
    end

    assert_redirected_to wmail_path(assigns(:wmail))
  end

  test "should show wmail" do
    get :show, :id => @wmail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @wmail.to_param
    assert_response :success
  end

  test "should update wmail" do
    put :update, :id => @wmail.to_param, :wmail => @wmail.attributes
    assert_redirected_to wmail_path(assigns(:wmail))
  end

  test "should destroy wmail" do
    assert_difference('Wmail.count', -1) do
      delete :destroy, :id => @wmail.to_param
    end

    assert_redirected_to wmails_path
  end
end
