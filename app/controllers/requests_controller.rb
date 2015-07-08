class RequestsController < ApplicationController
  require 'csv'

  before_filter :check_session, :only => [:show]
  before_filter :auth, :only => [:destroy, :index]  

  def create
    
    @request = Request.new(request_params_with_tree_and_addy)

    respond_to do |format|
      if @request.save
        @tree = @request.tree
        @tree.stock -= 1
        @tree.save

        format.html { redirect_to @request, notice: 'Your tree has been reserved.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.json { render json: @request.errors, status: :unprocessable_entity }
        format.html { redirect_to Giveaway.find(request_params[:giveaway_id]), notice: @request.errors }
      end
    end
  end

  def destroy
    @request = Request.find(params[:id])
    
    respond_to do |format|
      if @request.destroy
        @tree = @request.tree
        @tree.stock += 1
        @tree.save

        format.html { redirect_to giveaways_path, notice: 'Request has been deleted' }
      end
    end
  end

  def index
    @giveaway = Giveaway.find(params[:id])
    @requests = Request.where(giveaway_id: @giveaway.id)

    respond_to do |format|
      format.html
      format.csv { send_data @requests.to_csv }
    end

  end

  def show
    @request = Request.find(params[:id])
  end

  private

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :phone_number, 
                                    :mailing_street1, :mailing_street2, :mailing_city, :mailing_state, :mailing_zip,
                                    :planting_street1, :planting_street2, :planting_city, :planting_state, :planting_zip,
                                    :different_address, :referral, :tree, :giveaway_id, :session_id)
  end

  def request_params_with_tree_and_addy
    rp = request_params
    tree_id = rp[:tree]
    tree_ref = Tree.find(tree_id)
    rp[:tree] = tree_ref
    
    unless rp[:different_address] == 1
      rp[:planting_street1] = rp[:mailing_street1]
      rp[:planting_street2] = rp[:mailing_street2]
      rp[:planting_city] = rp[:mailing_city]
      rp[:planting_state] = rp[:mailing_state]
      rp[:planting_zip] = rp[:mailing_zip]
    end

    rp
  end

  def admin?
    session.id == Su.find(1).session_id
  end

  def check_session
    unless admin? || Request.find(params[:id]).session_id == session.id
      render :text => "You can only see a request you just made.", :status => 403
    end
  end

  def auth
    unless admin?
      render :text => "You must be logged in to see this page", :status => 403
    end
  end

end
