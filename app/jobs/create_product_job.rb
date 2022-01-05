class CreateProductJob < ApplicationJob

  def self.perform(payload)
    p "Inside TestJob"
    payload = JSON.parse(payload)
    product_name = payload["name"]
    stock = payload["stock"]
    p payload
    Product.find_or_create_by(name: product_name, stock: stock)
  end

end