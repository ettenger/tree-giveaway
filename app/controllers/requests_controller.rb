class RequestsController < ApplicationController
  require 'csv'

  before_filter :check_session, :only => [:show]
  before_filter :auth, :only => [:destroy, :index, :edit, :update, :delete_all]

  def create
    
    @request = Request.new(request_params_with_tree_and_addy)
    @giveaway = Giveaway.find(request_params[:giveaway_id])

    if Request.where(giveaway_id: @request.giveaway_id).map(&:planting_address).include? @request.planting_address
      redirect_to @giveaway, notice: "Tree not reserved. You may only make one request per planting address."
      return
    end
      
    @tree = @request.tree
    @tree2 = @request.tree2 if @request.tree2_id

    # Guard against reserving out of stock trees
    if @tree.stock < 1 || @tree2 && (@tree2.stock < 1 || @tree == @tree2 && @tree.stock < 2)
      redirect_to @giveaway, notice: "Sorry, the tree you reqeusted is no longer available."
      return
    end

    if @request.save
      @tree.stock -= 1
      @tree.save

      if @request.tree2_id
        @tree2.stock -= 1
        @tree2.save
      end

      if @request.one_time_link_code
        @giveaway.use_code!(@request.one_time_link_code)
        @giveaway.save
      end

      Mailer.conf_email(@request).deliver_now
      
      redirect_to @request, notice: 'Your tree has been reserved.'
    else
      redirect_to Giveaway.find(request_params[:giveaway_id]), notice: @request.errors
    end
  end

  def edit
    @request = Request.find(params[:id])
    @trees = @request.giveaway.trees
    @old_tree_id = @request.tree_id
    @old_tree2_id = @request.tree2_id
  end

  def update
    @request = Request.find(params[:id])
    respond_to do |format|
     tp = tree_params
     old_tree_id =  tp.delete("old_tree_id")
     old_tree2_id =  tp.delete("old_tree2_id")
     tree_id = tp[:tree].id
     tree2_id = tp[:tree2_id]

     if @request.update(tp)
        unless old_tree_id.blank?
          @tree_old = Tree.find(old_tree_id)
          @tree_old.stock += 1
          @tree_old.save
        end

        unless old_tree2_id.blank?
          @tree2_old = Tree.find(old_tree2_id)
          @tree2_old.stock += 1
          @tree2_old.save
        end

        unless tree_id.blank?
          @tree = Tree.find(tree_id)
          @tree.stock -= 1
          @tree.save
        end

        unless tree2_id.blank?
          @tree2 = Tree.find(tree2_id)
          @tree2.stock -= 1
          @tree2.save
        end
        
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
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

  def delete_all
    Request.delete_all
    flash[:notice] = "You have removed all requests!"
    redirect_to su_home_path
  end

  private

  def request_params
    giveaway_id = params.require(:request).fetch(:giveaway_id)
    tree_ids = Giveaway.find(giveaway_id).trees.ids.map(&:to_s)
    params.require(:request).permit(:first_name, :last_name, :email, :phone_number, :one_time_link_code,
                                    :mailing_street1, :mailing_street2, :mailing_city, :mailing_state, :mailing_zip,
                                    :planting_street1, :planting_street2, :planting_city, :planting_state, :planting_zip,
                                    :different_address, :referral, :giveaway_id, :session_id, :old_tree_id, :old_tree2_id,
                                    :is_cell_phone, :previously_attended,
                                    :tree => tree_ids)
  end

  def tree_params
    rp = request_params
    sorted_tree_requests = rp[:tree].sort_by { |k, v| v}.reverse
    tree_request1 = sorted_tree_requests[0]
    tree_request2 = sorted_tree_requests[1]

    tree_ref1 = Tree.find(tree_request1[0])
    tree2_id = nil

    if tree_request1[1] == "2"
      tree2_id = tree_ref1.id
    elsif tree_request2 && tree_request2[1] == "1"
      tree2_id = tree_request2[0].to_i
    end

    rp[:tree] = tree_ref1
    rp[:tree2_id] = tree2_id

    rp
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
    elsif tree_request2 && tree_request2[1] == "1"
      tree2_id = tree_request2[0].to_i
    end

    rp[:tree] = tree_ref1
    rp[:tree2_id] = tree2_id
    
    unless rp[:different_address] == "true"
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
