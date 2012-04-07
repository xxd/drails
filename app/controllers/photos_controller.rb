class PhotosController < ApplicationController
  respond_to :json
    
  def create
    respond_with(@photo = current_user.photos.create(params[:photo]))
  end
  
  def show
    respond_with(@photo = Photo.find_by_id(params[:id]))
  end
end
