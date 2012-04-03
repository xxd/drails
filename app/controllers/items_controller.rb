class ItemsController < ApplicationController
  def create
    @item = current_user.items.create(params[:item])
  end
end
