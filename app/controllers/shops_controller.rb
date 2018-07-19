class ShopsController < ApplicationController
  def list
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
        copies_in_stock: supply.books_in_stock
      }
      map
    end.values.sort_by{ |data| -data[:books_sold_count] }
    render json: {shops: result}
  end

  def sell
    supply = Supply.where(book_id: params[:book_id], shop_id: params[:shop_id]).first
    if !supply
      render json: 'not_found'
    else
      count = params[:count].to_i
      if count == 0
        render json: 'wrong_count'
      elsif supply.books_in_stock < count
        render json: 'not_in_stock'
      else
        supply.books_sold += count
        supply.save
        render json: 'ok'
      end
    end
  end
end
