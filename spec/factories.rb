FactoryBot.define do
  factory :publisher do
    sequence(:name) { |n| "Publisher #{n}" }
  end

  factory :book do
    publisher
    sequence(:title) { |n| "Title #{n}" }
  end

  factory :shop do
    sequence(:name) { |n| "Shop #{n}" }
  end

  factory :supply do
    book
    shop
    books_supplied 0
    books_sold 0
  end
end
