class LevelsController < ApplicationController
  
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
    @levels = Level.order(:name)
  end
  
  
  private
  
  def level_params
    params.require(:level).permit(:name, :img_src, :solution)
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
 
end
