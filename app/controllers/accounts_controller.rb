class AccountsController < ApplicationController
  before_action :set_account, only: %i(
    show
    update
    destroy
    block
    unblock
    cancel
    uncancel
  )

  # GET /accounts
  def index
    @accounts = Account.all

    render json: @accounts
  end

  # GET /accounts/1
  def show
    render json: @account
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # POST /accounts/1/block
  def block
    @account.update!(is_blocked: true)
  end

  # POST /accounts/1/unblock
  def unblock
    @account.update!(is_blocked: false)
  end

  # POST /accounts/1/cancel
  def cancel
    @account.update!(is_canceled: true)
  end

  # POST /accounts/1/uncancel
  def uncancel
    @account.update!(is_canceled: false)
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(:account).permit(
        :is_child,
        :root_id,
        :parent_id,
        :owner_id,
        :name
      )
    end
end
