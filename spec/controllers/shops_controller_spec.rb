require 'rails_helper'

RSpec.describe ShopsController, type: :controller do

  describe 'GET #index' do
    let(:publisher) { create(:publisher) }
    let(:book) { create(:book, publisher: publisher) }
    let(:shop) { create(:shop) }
    let(:supply) { create(:supply, book: book, shop: shop, books_supplied: 10, books_sold: 3) }

    before { supply }

    def json
      get :index, params: { publisher_id: publisher.id }
      JSON.parse(response.body)
    end

    context 'given publisher id' do
      it 'finds retailer shops' do
        retailer_shops = json['shops'].select{ |s| s['id'] == publisher.id  }
        expect(retailer_shops.size).to eq(1)
      end

      it 'ignores unrelated shops' do
        another_shop = create(:shop)
        expect(json['shops'].size).to eq(1)
      end

      it 'orders shops by number of books sold' do
        shop_2 = create(:shop)
        supply_2 = create(:supply, shop: shop_2, book: book, books_supplied: 10, books_sold: 8)

        shop_3 = create(:shop)
        supply_3 = create(:supply, shop: shop_3, book: book, books_supplied: 10, books_sold: 5)

        shop_ids = json['shops'].map{ |data| data['id'] }
        expect(shop_ids).to eq([shop_2.id, shop_3.id, shop.id])
      end

      it 'ignores books that are not in stock' do
        book_2 = create(:book, publisher: publisher)
        supply_2 = create(:supply, shop: shop, book: book_2, books_supplied: 10, books_sold: 10)

        book_ids = json['shops'][0]['books_in_stock'].map{ |data| data['id'] }
        expect(book_ids).not_to include(book_2.id)
      end

      it 'sums books_sold_count for shop' do
        book_2 = create(:book, publisher: publisher)
        supply_2 = create(:supply, shop: shop, book: book_2, books_supplied: 20, books_sold: 9)

        books_sold_count = json['shops'][0]['books_sold_count']
        expect(books_sold_count).to eq(12)
      end
    end

    context 'given wrong id' do
      it 'returns []' do
        get :index, params: { publisher_id: 'wrong' }
        json = JSON.parse(response.body)
        expect(json['shops']).to eq([])
      end
    end
  end
end
