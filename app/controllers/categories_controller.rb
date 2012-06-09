class CategoriesController < ApplicationController
  respond_to :json
  
  def index
  	respond_with(@categories = Category.all)
  end

  def show
    respond_with(@category = Category.find_by_id(params[:id]))
  end
  
  def sync
    respond_with(@category = Category.where("id > :id", {:id => params[:id]}))
  end
end
