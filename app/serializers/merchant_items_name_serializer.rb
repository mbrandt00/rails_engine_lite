class MerchantItemsNameSerializer
  include JSONAPI::Serializer
  attributes :name
  attributes :count do |object|
    object.sum
  end
end
