class RequestsController < ApplicationController
  def create
    @request = Request.new(request_params_with_tree)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Your tree has been reserved.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def index
  end

  def show
    @request = Request.find(params[:id])
  end

  private

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :tree, :giveaway_id)
  end

  def request_params_with_tree
    rp = request_params
    tree_id = rp[:tree]
    tree_ref = Tree.find(tree_id)
    rp[:tree] = tree_ref
    rp
  end

end
