class RequestController < ApplicationController
  def create
  end

  def destroy
  end

  def index
  end

  def show
  end

  private

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :tree_id, :giveaway_id)
  end

end
