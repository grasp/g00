require 'test_helper'

class SitedataControllerTest < ActionController::TestCase
  setup do
    @sitedatum = sitedata(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sitedata)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sitedatum" do
    assert_difference('Sitedatum.count') do
      post :create, :sitedatum => @sitedatum.attributes
    end

    assert_redirected_to sitedatum_path(assigns(:sitedatum))
  end

  test "should show sitedatum" do
    get :show, :id => @sitedatum.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sitedatum.to_param
    assert_response :success
  end

  test "should update sitedatum" do
    put :update, :id => @sitedatum.to_param, :sitedatum => @sitedatum.attributes
    assert_redirected_to sitedatum_path(assigns(:sitedatum))
  end

  test "should destroy sitedatum" do
    assert_difference('Sitedatum.count', -1) do
      delete :destroy, :id => @sitedatum.to_param
    end

    assert_redirected_to sitedata_path
  end
end
