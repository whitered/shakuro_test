class Supply < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  def self.for_publisher(pub_id)
    Supply
      .includes(:book)
      .where('books.publisher_id = ?', pub_id)
      .where('books_supplied - books_sold > 0')
      .references(:book)
  end
end
