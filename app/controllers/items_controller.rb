class ItemsController < ApplicationController
  respond_to :json
  def create
    @item = current_user.items.create(params[:item])
  end
  
  def show
    @photo_item = current_user.photos.where("item_id = :id", {:id => params[:id]})
    @song_item = current_user.songs.where("item_id = :id", {:id => params[:id]})
    @voice_item = current_user.voices.where("item_id = :id", {:id => params[:id]})
    respond_with(@photo_item, @song_item, @voice_item)
  end
  
  def sync
    respond_with(@item = Item.where("id > :id", {:id => params[:id]}))
  end
  
  def fork
    origin = Item.find_by_id params[:origin_id]
    @fork = current_user.items.create("list_id"=>params[:list_id],"name"=>origin.name,"content"=>origin.content)
  end
end
