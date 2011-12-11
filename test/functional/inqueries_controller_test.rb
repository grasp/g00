require 'test_helper'

class InqueriesControllerTest < ActionController::TestCase
  setup do
    @inquery = inqueries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inqueries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inquery" do
    assert_difference('Inquery.count') do
      post :create, :inquery => @inquery.attributes
    end

    assert_redirected_to inquery_path(assigns(:inquery))
  end

  test "should show inquery" do
    get :show, :id => @inquery.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @inquery.to_param
    assert_response :success
  end

  test "should update inquery" do
    put :update, :id => @inquery.to_param, :inquery => @inquery.attributes
    assert_redirected_to inquery_path(assigns(:inquery))
  end

  test "should destroy inquery" do
    assert_difference('Inquery.count', -1) do
      delete :destroy, :id => @inquery.to_param
    end

    assert_redirected_to inqueries_path
  end
end
