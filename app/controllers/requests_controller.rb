class RequestsController < ApplicationController
  require 'csv'

  before_filter :check_session, :only => [:show]
  before_filter :auth, :only => [:destroy, :index]  

  def create
    
    @request = Request.new(request_params_with_tree_and_addy)

    if Request.where(giveaway_id: @request.giveaway_id).map(&:planting_address).include? @request.planting_address
      redirect_to Giveaway.find(request_params[:giveaway_id]), notice: "Tree not reserved. You may only request one tree per planting address."
      return
    end
      

    respond_to do |format|
      if @request.save
        @tree = @request.tree
        @tree.stock -= 1
        @tree.save

        if @request.tree2_id
          @tree2 = @request.tree2
          @tree2.stock -= 1
          @tree2.save
        end

        Mailer.conf_email(@request).deliver_now
        
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

        if @request.tree2_id
          @tree2 = @request.tree2
          @tree2.stock += 1
          @tree2.save
        end

        format.html { redirect_to giveaways_path, notice: 'Request has been deleted' }
      end
    end
  end

  def index
    if params[:id] == "all"
      @requests = Request.all
    else
      @giveaway = Giveaway.find(params[:id])
      @requests = Request.where(giveaway_id: @giveaway.id)
    end

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
    giveaway_id = params.require(:request).fetch(:giveaway_id)
    tree_ids = Giveaway.find(giveaway_id).trees.ids.map(&:to_s)
    params.require(:request).permit(:first_name, :last_name, :email, :phone_number, 
                                    :mailing_street1, :mailing_street2, :mailing_city, :mailing_state, :mailing_zip,
                                    :planting_street1, :planting_street2, :planting_city, :planting_state, :planting_zip,
                                    :different_address, :referral, :giveaway_id, :session_id, :tree => tree_ids)
  end

  def request_params_with_tree_and_addy
    rp = request_params
    sorted_tree_requests = rp[:tree].sort_by { |k, v| v}.reverse
    tree_request1 = sorted_tree_requests[0]
    tree_request2 = sorted_tree_requests[1]

    tree_ref1 = Tree.find(tree_request1[0])
    tree2_id = nil

    if tree_request1[1] == "2"
      tree2_id = tree_ref1.id
    elsif tree_request2[1] == "1"
      tree2_id = tree_request2[0].to_i
    end

    rp[:tree] = tree_ref1
    rp[:tree2_id] = tree2_id
    
    unless rp[:different_address] == "1"
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
