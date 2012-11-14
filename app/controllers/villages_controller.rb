class VillagesController < ApplicationController
  def index
    @villages = Village.all
  end

  def show
    @village = Village.find(params[:id])
  end

  def create
    @village = Village.new(params[:village])
    if @village.save
      redirect_to @village, notice: 'Successfully created.'
    else
      # TODO
      redirect_to villages_path, alert: 'ERROR'
    end
  end
end
