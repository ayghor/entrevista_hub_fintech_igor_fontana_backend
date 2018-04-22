require 'test_helper'

class TransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transfer = transfers(:one)
  end

  test "should get index" do
    get transfers_url, as: :json
    assert_response :success
  end

  test "should create transfer" do
    assert_difference('Transfer.count') do
      post transfers_url, as: :json, params: {
        transfer: {
          amount: @transfer.amount,
          code: "zzzzzzzzzzzzzzzzzzzzzz",
          from_id: @transfer.from_id,
          to_id: @transfer.to_id,
          is_child: @transfer.is_child,
          is_reversal: @transfer.is_reversal
        }
      }
    end

    assert_response 201
  end

  test "should show transfer" do
    get transfer_url(@transfer), as: :json
    assert_response :success
  end

  test "should update transfer" do
    patch transfer_url(@transfer), as: :json, params: {
      transfer: {
        amount: @transfer.amount,
        code: @transfer.code,
        from_id: @transfer.from_id,
        reverse_id: @transfer.reverse_id,
        to_id: @transfer.to_id,
        is_child: @transfer.is_child,
        is_reversal: @transfer.is_reversal
      }
    }
    assert_response 200
  end
end