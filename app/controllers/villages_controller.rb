class VillagesController < ApplicationController
  before_filter :require_login, only: [:join, :quit]
  before_filter :find_village, only: [:join, :quit]

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

  def join
    @village.villagers << current_user
    redirect_to @village, notice: "You just joined this village!"
  end

  def quit
    @village.villagers.delete current_user
    redirect_to @village, notice: "You just quit this village!"
  end

  private

  def find_village
    @village = Village.find(params[:id])
  end
end
