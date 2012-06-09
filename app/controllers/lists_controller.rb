class ListsController < ApplicationController
  respond_to :json
  
  def index
    respond_with(@lists = current_user.categories)
  end
  
  def create
    respond_with(@list = current_user.lists.create(params[:list]))
  end
  
  def show
    respond_with(@list = List.find_by_id(params[:id]))
  end
  
  def sync
    respond_with(@list = List.where("id > :id", {:id => params[:id]}))
  end
end
