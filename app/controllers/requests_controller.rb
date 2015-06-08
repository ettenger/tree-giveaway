class RequestsController < ApplicationController
  before_filter :check_session, :only => [:show]
  before_filter :auth, :only => [:destroy, :index]  

  def create
    @request = Request.new(request_params_with_tree)

    respond_to do |format|
      if @request.save
        @tree = @request.tree
        @tree.stock -= 1
        @tree.save

        format.html { redirect_to @request, notice: 'Your tree has been reserved.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.json { render json: @request.errors, status: :unprocessable_entity }
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
  end

  def show
    @request = Request.find(params[:id])
  end

  private

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :tree, :giveaway_id, :session_id)
  end

  def request_params_with_tree
    rp = request_params
    tree_id = rp[:tree]
    tree_ref = Tree.find(tree_id)
    rp[:tree] = tree_ref
    rp
  end

  def check_session
    unless Request.find(params[:id]).session_id == session.id
      render :text => "You can only see a request you just made.", :status => 403
    end
  end

  def auth
    unless session.id == Su.find(1).session_id
      render :text => "You must be logged in to see this page", :status => 403
    end
  end
end
