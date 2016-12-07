class ItemsController < ApplicationController

  def index
    # Use: @ads = Ad.all (NOT @ads = Ad.find(:all)) Model.all is deprecated
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

end
