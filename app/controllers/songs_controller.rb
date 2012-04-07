class SongsController < ApplicationController
  respond_to :json
  
  def create
    respond_with(@song = current_user.songs.create(params[:song]))
  end
  
  def show
    respond_with(@song = Song.find_by_id(params[:id]))
  end
end
