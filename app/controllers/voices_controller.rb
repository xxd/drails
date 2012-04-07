class VoicesController < ApplicationController
  respond_to :json
  
  def create
    respond_with(@voice = current_user.voices.create(params[:voice]))
  end
  
  def show
    respond_with(@voice = Voice.find_by_id(params[:id]))
  end
end
