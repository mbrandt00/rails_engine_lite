FactoryBot.define do
  factory :item, class: Item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4) }
    unit_price { rand(1.1..20.1).round(2) }
    merchant
  end
end