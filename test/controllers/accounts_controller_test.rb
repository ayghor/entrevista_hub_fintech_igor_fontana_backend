require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url, as: :json
    assert_response :success
  end

  test "should get index for person" do
    get person_accounts_url(@account.owner), as: :json
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url, as: :json, params: {
        account: {
          owner_id: @account.owner_id,
          name: "Unused name",
          amount: 666,
        }
      }
    end

    assert_response 201
  end

  test "should show account" do
    get account_url(@account), as: :json
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), as: :json, params: {
      account: {
        parent_id: @account.parent_id,
        root_id: @account.root_id,
        owner_id: @account.owner_id,
        name: @account.name,
      }
    }
    assert_response 200
  end

  test "should block and unblock account" do
    refute @account.is_blocked
    post block_account_url(@account), as: :json
    assert_response 204
    @account.reload

    assert @account.is_blocked
    post unblock_account_url(@account), as: :json
    assert_response 204
    @account.reload

    refute @account.is_blocked
  end

  test "should cancel and uncancel account" do
    refute @account.is_canceled
    post cancel_account_url(@account), as: :json
    assert_response 204
    @account.reload

    assert @account.is_canceled
    post uncancel_account_url(@account), as: :json
    assert_response 204
    @account.reload

    refute @account.is_canceled
  end
end
