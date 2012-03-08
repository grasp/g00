require 'test_helper'

class LineAdsControllerTest < ActionController::TestCase
  setup do
    @line_ad = line_ads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_ads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_ad" do
    assert_difference('LineAd.count') do
      post :create, :line_ad => @line_ad.attributes
    end

    assert_redirected_to line_ad_path(assigns(:line_ad))
  end

  test "should show line_ad" do
    get :show, :id => @line_ad.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @line_ad.to_param
    assert_response :success
  end

  test "should update line_ad" do
    put :update, :id => @line_ad.to_param, :line_ad => @line_ad.attributes
    assert_redirected_to line_ad_path(assigns(:line_ad))
  end

  test "should destroy line_ad" do
    assert_difference('LineAd.count', -1) do
      delete :destroy, :id => @line_ad.to_param
    end

    assert_redirected_to line_ads_path
  end
end
