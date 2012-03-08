require 'test_helper'

class CargoCategoriesControllerTest < ActionController::TestCase
  setup do
    @cargo_category = cargo_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargo_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo_category" do
    assert_difference('CargoCategory.count') do
      post :create, :cargo_category => @cargo_category.attributes
    end

    assert_redirected_to cargo_category_path(assigns(:cargo_category))
  end

  test "should show cargo_category" do
    get :show, :id => @cargo_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cargo_category.to_param
    assert_response :success
  end

  test "should update cargo_category" do
    put :update, :id => @cargo_category.to_param, :cargo_category => @cargo_category.attributes
    assert_redirected_to cargo_category_path(assigns(:cargo_category))
  end

  test "should destroy cargo_category" do
    assert_difference('CargoCategory.count', -1) do
      delete :destroy, :id => @cargo_category.to_param
    end

    assert_redirected_to cargo_categories_path
  end
end
