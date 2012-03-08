require 'test_helper'

class MailAccountsControllerTest < ActionController::TestCase
  setup do
    @mail_account = mail_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_account" do
    assert_difference('MailAccount.count') do
      post :create, :mail_account => @mail_account.attributes
    end

    assert_redirected_to mail_account_path(assigns(:mail_account))
  end

  test "should show mail_account" do
    get :show, :id => @mail_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mail_account.to_param
    assert_response :success
  end

  test "should update mail_account" do
    put :update, :id => @mail_account.to_param, :mail_account => @mail_account.attributes
    assert_redirected_to mail_account_path(assigns(:mail_account))
  end

  test "should destroy mail_account" do
    assert_difference('MailAccount.count', -1) do
      delete :destroy, :id => @mail_account.to_param
    end

    assert_redirected_to mail_accounts_path
  end
end
