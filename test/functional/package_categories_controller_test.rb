require 'test_helper'

class PackageCategoriesControllerTest < ActionController::TestCase
  setup do
    @package_category = package_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:package_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package_category" do
    assert_difference('PackageCategory.count') do
      post :create, :package_category => @package_category.attributes
    end

    assert_redirected_to package_category_path(assigns(:package_category))
  end

  test "should show package_category" do
    get :show, :id => @package_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @package_category.to_param
    assert_response :success
  end

  test "should update package_category" do
    put :update, :id => @package_category.to_param, :package_category => @package_category.attributes
    assert_redirected_to package_category_path(assigns(:package_category))
  end

  test "should destroy package_category" do
    assert_difference('PackageCategory.count', -1) do
      delete :destroy, :id => @package_category.to_param
    end

    assert_redirected_to package_categories_path
  end
end
