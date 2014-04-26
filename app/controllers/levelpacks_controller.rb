class LevelpacksController < ApplicationController
  
  def new
    
  end
  
  def show
    @levelpack = Levelpack.find_by(id: params[:id])
  end
end