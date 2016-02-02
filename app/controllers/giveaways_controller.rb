class GiveawaysController < ApplicationController
  before_filter :auth, only: [:index, :new, :edit, :update, :destroy, :create]
  before_action :set_giveaway, only: [:show, :edit, :update, :destroy]

  # GET /giveaways
  # GET /giveaways.json
  def index
    @giveaways = Giveaway.all
  end

  # GET /giveaways/1
  # GET /giveaways/1.json
  def show
    session[:init] = true
    @request = Request.new
  end

  # GET /giveaways/new
  def new
    defaults = {:max_trees => 2,
                :referral => "Newspaper\nFlyer\nEmail\nSocial media (Facebook, Twitter, Instagram)\nOnline search\nBlog post\nTreePhilly website\nWord of mouth\nI am a return participant\nOther"}
    @giveaway = Giveaway.new(defaults)
    @trees = Tree.all
  end

  # GET /giveaways/1/edit
  def edit
    @trees = Tree.all
  end

  # POST /giveaways
  # POST /giveaways.json
  def create
    @giveaway = Giveaway.new(giveaway_params_with_trees)

    respond_to do |format|
      if @giveaway.save
        format.html { redirect_to @giveaway, notice: 'Giveaway was successfully created.' }
        format.json { render :show, status: :created, location: @giveaway }
      else
        format.html { render :new }
        format.json { render json: @giveaway.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /giveaways/1
  # PATCH/PUT /giveaways/1.json
  def update
    respond_to do |format|
       if @giveaway.update(giveaway_params_with_trees)
        format.html { redirect_to @giveaway, notice: 'Giveaway was successfully updated.' }
        format.json { render :show, status: :ok, location: @giveaway }
      else
        format.html { render :edit }
        format.json { render json: @giveaway.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /giveaways/1
  # DELETE /giveaways/1.json
  def destroy
    @giveaway.destroy
    respond_to do |format|
      format.html { redirect_to giveaways_url, notice: 'Giveaway was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_giveaway
      @giveaway = Giveaway.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def giveaway_params
      params.require(:giveaway).permit(:name, :description, :description2, :location, :time, :end_time, :max_trees, :tree_limit, :close_time, :confirmation_text, :referral, {:trees => []})
    end

    def giveaway_params_with_trees
      gp = giveaway_params
      
      if gp[:trees]
        tree_ids = gp[:trees].reject(&:blank?)
        tree_refs = Tree.find(tree_ids)
        gp[:trees] = tree_refs
      end
      
      gp
    end

  def auth
    unless session.id == Su.find(1).session_id
      render :text => "You must be logged in to see this page", :status => 403
    end
  end
end
