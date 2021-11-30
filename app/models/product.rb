class Product < ApplicationRecord

  def to_proto
    Pim::Product.new(
      id: id.to_i,
      name: name.to_s,
      stock: stock.to_f
    )
  end
end
