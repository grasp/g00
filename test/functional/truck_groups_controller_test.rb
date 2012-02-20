require 'test_helper'

class TruckGroupsControllerTest < ActionController::TestCase
  setup do
    @truck_group = truck_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:truck_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create truck_group" do
    assert_difference('TruckGroup.count') do
      post :create, truck_group: @truck_group.attributes
    end

    assert_redirected_to truck_group_path(assigns(:truck_group))
  end

  test "should show truck_group" do
    get :show, id: @truck_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @truck_group
    assert_response :success
  end

  test "should update truck_group" do
    put :update, id: @truck_group, truck_group: @truck_group.attributes
    assert_redirected_to truck_group_path(assigns(:truck_group))
  end

  test "should destroy truck_group" do
    assert_difference('TruckGroup.count', -1) do
      delete :destroy, id: @truck_group
    end

    assert_redirected_to truck_groups_path
  end
end
