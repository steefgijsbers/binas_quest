class LevelpacksController < ApplicationController
  
  def new
    @levelpack = Levelpack.new
  end
  
  def show
    @levelpack = Levelpack.find_by(id: params[:id])
  end
  
  def create
    @levelpack = Levelpack.new(levelpack_params)
    if @levelpack.save
      flash[:success] = "Levelpack has been succesfully created."
      redirect_to levelpacks_path
    else
      render 'new'
    end
  end
  
  def index
    @levelpacks = Levelpack.paginate(page: params[:page])
  end
  
  
  private
  
    def levelpack_params
      params.require(:levelpack).permit(:name, :title)
    end
end