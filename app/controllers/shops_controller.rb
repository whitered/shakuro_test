class ShopsController < ApplicationController
  def index
    publisher = Publisher.find_by_id params[:publisher_id]
    shops = Shop.all
    render json: {shops: shops}
  end
end
