require 'test_helper'

class InquiryControllerTest < ActionController::TestCase
  test "should get price_min:integer" do
    get :price_min:integer
    assert_response :success
  end

  test "should get price_aver:integer" do
    get :price_aver:integer
    assert_response :success
  end

  test "should get price_max:integer" do
    get :price_max:integer
    assert_response :success
  end

  test "should get comments:string" do
    get :comments:string
    assert_response :success
  end

  test "should get habit_word:string" do
    get :habit_word:string
    assert_response :success
  end

  test "should get cargo_id:integer" do
    get :cargo_id:integer
    assert_response :success
  end

  test "should get truck_id:integer" do
    get :truck_id:integer
    assert_response :success
  end

  test "should get user_id:integer" do
    get :user_id:integer
    assert_response :success
  end

end
