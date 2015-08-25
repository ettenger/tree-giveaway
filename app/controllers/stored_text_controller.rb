class StoredTextController < ApplicationController
  before_filter :auth

  def edit
    @stored_text = StoredText.find(params[:id])
  end

  def update
    @stored_text = StoredText.find(params[:id])
    respond_to do |format|
      if @stored_text.update(stored_text_params)
        format.html { redirect_to :su_home, notice: 'Text was successfully updated.' }
        format.json { render :show, status: :ok, location: @stored_text }
      else
        format.html { render :edit }
        format.json { render json: @stored_text.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def stored_text_params
      params.require(:stored_text).permit(:name, :the_text)
  end

  def auth
    unless session.id == Su.find(1).session_id
      render :text => "You must be logged in to see this page", :status => 403
    end
  end

end
