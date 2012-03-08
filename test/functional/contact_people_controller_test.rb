require 'test_helper'

class ContactPeopleControllerTest < ActionController::TestCase
  setup do
    @contact_person = contact_people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_person" do
    assert_difference('ContactPerson.count') do
      post :create, :contact_person => @contact_person.attributes
    end

    assert_redirected_to contact_person_path(assigns(:contact_person))
  end

  test "should show contact_person" do
    get :show, :id => @contact_person.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @contact_person.to_param
    assert_response :success
  end

  test "should update contact_person" do
    put :update, :id => @contact_person.to_param, :contact_person => @contact_person.attributes
    assert_redirected_to contact_person_path(assigns(:contact_person))
  end

  test "should destroy contact_person" do
    assert_difference('ContactPerson.count', -1) do
      delete :destroy, :id => @contact_person.to_param
    end

    assert_redirected_to contact_people_path
  end
end
