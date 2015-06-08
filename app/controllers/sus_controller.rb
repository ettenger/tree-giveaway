class SusController < ApplicationController
  before_filter :auth, :only => [:home]
  
  def home
  end
  
  def login
    @su = Su.new
  end

  def update
    su1 = Su.find(1)
    if su_params[:password] == su1.password
      su1.session_id = su_params[:session_id]
      su1.save
      redirect_to su_home_path, notice: "Logged in successfully"
    else
      redirect_to login_path, notice: "Wrong password"
    end
  end

  def clear
    su1 = Su.find(1)
    su1.session_id = nil
    su1.save
    redirect_to login_path, notice: "Logged out"
  end

  private
    def su_params
      params.require(:su).permit(:session_id, :password)
    end

  def auth
    unless session.id == Su.find(1).session_id
      render :text => "You must be logged in to see this page", :status => 403
    end
  end
end
