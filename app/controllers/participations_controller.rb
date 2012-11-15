class ParticipationsController < ApplicationController
  before_filter :require_login

  def create
    @village = Village.find(params[:village_id])
    @participation = @village.participations.new
    @participation.user = current_user

    @participation.save!
    redirect_to @village, notice: "You just joined this village!"
  end

  def destroy
    @village = Village.find(params[:village_id])
    @village.villagers.delete current_user

    redirect_to @village, notice: "You just quit this village!"
  end
end