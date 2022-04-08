FactoryBot.define do
  factory :invoice, class: Invoice do
    status { (%w[completed cancelled inprogress]).sample(1)[0] }
    customer
  end
end
