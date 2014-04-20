class LevelsController < ApplicationController
  before_action :admin_user
  
  def new
    @level = Level.new
  end
  
  def show
    @level = Level.find(params[:id])
  end
  
  def create
    @level = Level.new(level_params) 
    if @level.save
      flash[:success] = "Upload geslaagd."
      redirect_to @level
    else
      render 'new'
    end
  end
  
  def index
    @levels = Level.paginate(page: params[:page])
  end
  
  def destroy
    Level.find(params[:id]).destroy
    flash[:success] = "Level succesvol verwijderd"
    redirect_to levels_url
  end
  
  
  private
  
  def level_params
    params.require(:level).permit(:name, :img_src, :solution)
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
 
end
