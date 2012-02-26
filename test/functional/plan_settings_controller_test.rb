require 'test_helper'

class PlanSettingsControllerTest < ActionController::TestCase
  setup do
    @plan_setting = plan_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plan_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plan_setting" do
    assert_difference('PlanSetting.count') do
      post :create, plan_setting: @plan_setting.attributes
    end

    assert_redirected_to plan_setting_path(assigns(:plan_setting))
  end

  test "should show plan_setting" do
    get :show, id: @plan_setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plan_setting
    assert_response :success
  end

  test "should update plan_setting" do
    put :update, id: @plan_setting, plan_setting: @plan_setting.attributes
    assert_redirected_to plan_setting_path(assigns(:plan_setting))
  end

  test "should destroy plan_setting" do
    assert_difference('PlanSetting.count', -1) do
      delete :destroy, id: @plan_setting
    end

    assert_redirected_to plan_settings_path
  end
end
