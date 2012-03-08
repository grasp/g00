require 'test_helper'

class LibCompaniesControllerTest < ActionController::TestCase
  setup do
    @lib_company = lib_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lib_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lib_company" do
    assert_difference('LibCompany.count') do
      post :create, :lib_company => @lib_company.attributes
    end

    assert_redirected_to lib_company_path(assigns(:lib_company))
  end

  test "should show lib_company" do
    get :show, :id => @lib_company.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @lib_company.to_param
    assert_response :success
  end

  test "should update lib_company" do
    put :update, :id => @lib_company.to_param, :lib_company => @lib_company.attributes
    assert_redirected_to lib_company_path(assigns(:lib_company))
  end

  test "should destroy lib_company" do
    assert_difference('LibCompany.count', -1) do
      delete :destroy, :id => @lib_company.to_param
    end

    assert_redirected_to lib_companies_path
  end
end
