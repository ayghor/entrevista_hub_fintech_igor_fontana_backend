require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url, as: :json
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url, as: :json, params: {
        account: {
          amount: 666,
          name: "Unused name",
          owner_id: @account.owner_id,
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
        amount: @account.amount,
        root_id: @account.root_id,
        parent_id: @account.parent_id,
        name: @account.name,
        owner_id: @account.owner_id,
        is_blocked: @account.is_blocked,
        is_canceled: @account.is_canceled,
        is_child: @account.is_child
      }
    }
    assert_response 200
  end
end
