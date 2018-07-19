require 'rails_helper'

RSpec.describe ShopsController, type: :controller do

  describe 'GET #index' do
    let(:publisher) { create(:publisher) }
    let(:book) { create(:book, publisher: publisher) }
    let(:shop) { create(:shop) }
    let(:supply) { create(:supply, book: book, shop: shop) }

    before { supply }

    context 'given publisher id' do
      it 'finds retailer shops' do
        get :index, params: { publisher_id: publisher.id }
        json = JSON.parse(response.body)
        retailer_shops = json['shops'].select{ |s| s['id'] == publisher.id  }
        expect(retailer_shops.size).to eq(1)
      end
    end
  end

end
