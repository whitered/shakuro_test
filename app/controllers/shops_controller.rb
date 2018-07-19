class ShopsController < ApplicationController
  def index
    supplies = Supply.for_publisher(params[:publisher_id])
    result = supplies.inject({}) do |map, supply|
      shop = supply.shop
      shop_data = map[shop] ||= {
        id: shop.id,
        name: shop.name,
        books_sold_count: 0,
        books_in_stock: []
      }
      shop_data[:books_sold_count] += supply.books_sold
      shop_data[:books_in_stock] << {
        id: supply.book_id,
        title: supply.book.title,
        copies_in_stock: supply.books_supplied - supply.books_sold
      }
      map
    end.values.sort_by{ |data| -data[:books_sold_count] }
    render json: {shops: result}
  end
end
