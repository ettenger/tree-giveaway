class TreesController < ApplicationController
  before_filter :auth
  before_action :set_tree, only: [:show, :edit, :update, :destroy]

  # GET /trees
  # GET /trees.json
  def index
    @trees = Tree.all
  end

  # GET /trees/1
  # GET /trees/1.json
  def show
  end

  # GET /trees/new
  def new
    @tree = Tree.new
  end

  # GET /trees/1/edit
  def edit
    @show_original_stock = true
  end

  # POST /trees
  # POST /trees.json
  def create
    @tree = Tree.new(tree_params_with_original_stock)

    respond_to do |format|
      if @tree.save
        format.html { redirect_to @tree, notice: 'Tree was successfully created.' }
        format.json { render :show, status: :created, location: @tree }
      else
        format.html { render :new }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1
  # PATCH/PUT /trees/1.json
  def update
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to @tree, notice: 'Tree was successfully updated.' }
        format.json { render :show, status: :ok, location: @tree }
      else
        format.html { render :edit }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
    @tree.destroy
    respond_to do |format|
      format.html { redirect_to trees_url, notice: 'Tree was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree
      @tree = Tree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_params
      params.require(:tree).permit(:name, :description, :stock, :original_stock, :image)
    end

    def tree_params_with_original_stock
      tp = tree_params
      tp[:original_stock] = tree_params[:stock]
      tp
    end
  
  def auth
    unless session.id == Su.find(1).session_id
      render :text => "You must be logged in to see this page", :status => 403
    end
  end

end
