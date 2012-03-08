require 'test_helper'

class CargosControllerTest < ActionController::TestCase
  setup do
    @cargo = cargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo" do
    assert_difference('Cargo.count') do
      post :create, :cargo => @cargo.attributes
    end

    assert_redirected_to cargo_path(assigns(:cargo))
  end

  test "should show cargo" do
    get :show, :id => @cargo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cargo.to_param
    assert_response :success
  end

  test "should update cargo" do
    put :update, :id => @cargo.to_param, :cargo => @cargo.attributes
    assert_redirected_to cargo_path(assigns(:cargo))
  end

  test "should destroy cargo" do
    assert_difference('Cargo.count', -1) do
      delete :destroy, :id => @cargo.to_param
    end

    assert_redirected_to cargos_path
  end
end
