class CategoriesController < ApplicationController
  respond_to :json
  
  def show
    respond_with(@category = Category.find_by_id(params[:id]))
  end
  
  def syncCategory
    respond_with(@category = Category.where("id > :id", {:id => params[:id]}))
  end
end
