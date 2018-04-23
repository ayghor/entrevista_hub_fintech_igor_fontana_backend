class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :update, :destroy]

  # GET /transfers
  def index
    @transfers = Transfer.all

    if params.has_key?(:account_id)
      @transfers = @transfers.involving_account(params[:account_id])
    end

    @transfers.order!(created_at: :desc)

    render json: @transfers
  end

  # GET /transfers/1
  def show
    render json: @transfer
  end

  # POST /transfers
  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      render json: @transfer, status: :created, location: @transfer
    else
      render json: @transfer.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transfer_params
      params.require(:transfer).permit(
        :is_child,
        :is_reversal,
        :reverse_id,
        :code,
        :from_id,
        :to_id,
        :amount
      )
    end
end
