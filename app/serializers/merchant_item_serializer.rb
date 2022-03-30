class MerchantItemSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :items
end
