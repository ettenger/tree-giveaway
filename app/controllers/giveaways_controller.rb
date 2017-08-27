class GiveawaysController < ApplicationController
  before_filter :auth, only: [:index, :new, :edit, :update, :destroy, :create, :duplicate]
  before_action :set_giveaway, only: [:show, :edit, :update, :destroy]
  before_action :set_trees_and_logos, only: [:new, :edit, :duplicate]

  # GET /giveaways
  # GET /giveaways.json
  def index
    @giveaways = Giveaway.all
  end

  # GET /giveaways/1
  # GET /giveaways/1.json
  def show
    session[:init] = true
    @admin = true if auth?
    @code = params[:code]
    @show_giveaway =  !@giveaway.use_one_time_links || @admin || @giveaway.code_is_valid?(@code)
    @request = Request.new
  end

  # GET /giveaways/new
  def new
    defaults = {:max_trees => 2,
                :referral_question => "How did you hear about the TreePhilly Yard Tree Giveaways?",
                :referral => "Newspaper\nFlyer\nEmail\nSocial media (Facebook, Twitter, Instagram)\nOnline search\nBlog post\nTreePhilly website\nWord of mouth\nI am a return participant\nOther"}
    @giveaway = Giveaway.new(defaults)
  end

  def duplicate
    @original = Giveaway.find(params[:id])
    @giveaway = @original.dup
    @giveaway.trees = @original.trees
    render 'new'
  end

  # GET /giveaways/1/edit
  def edit
  end

  # POST /giveaways
  # POST /giveaways.json
  def create
    @giveaway = Giveaway.new(giveaway_params_with_trees)
    @giveaway.set_random_codes! if @giveaway.use_one_time_links

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
    if giveaway_params[:use_one_time_links] && !@giveaway.use_one_time_links
      @giveaway.set_random_codes!
    end

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

    def set_trees_and_logos
      @trees = Tree.order(:order)
      @logos = Logo.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def giveaway_params
      params.require(:giveaway).permit(:code, :name, :description, :description2, :referral_question,
                                       :logo1_id, :logo2_id, :logo3_id, :logo4_id, :logo5_id, :logo6_id,
                                       :location, :time, :end_time, :max_trees, :tree_limit,
                                       :close_time, :confirmation_text, :referral, :no_referral, 
                                       :no_philly_validation, :use_one_time_links, {:trees => []})
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

  def auth?
    session.id == Su.find(1).session_id
  end

  def auth
    unless auth?
      render :text => "You must be logged in to see this page", :status => 403
    end
  end
end
