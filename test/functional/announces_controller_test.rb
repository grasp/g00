require 'test_helper'

class AnnouncesControllerTest < ActionController::TestCase
  setup do
    @announce = announces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:announces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create announce" do
    assert_difference('Announce.count') do
      post :create, :announce => @announce.attributes
    end

    assert_redirected_to announce_path(assigns(:announce))
  end

  test "should show announce" do
    get :show, :id => @announce.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @announce.to_param
    assert_response :success
  end

  test "should update announce" do
    put :update, :id => @announce.to_param, :announce => @announce.attributes
    assert_redirected_to announce_path(assigns(:announce))
  end

  test "should destroy announce" do
    assert_difference('Announce.count', -1) do
      delete :destroy, :id => @announce.to_param
    end

    assert_redirected_to announces_path
  end
end
