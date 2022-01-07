class ProductsController < ::Gruf::Controllers::Base
  bind ::Pim::Products::Service

  def get_product
    product = ::Product.find(request.message.id.to_i)
    Pim::GetProductResp.new(
      product: Pim::Product.new(
        id: product.id,
        name: product.name,
        stock: product.stock
      )
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace)
    fail!(:not_found, :product_not_found, "Failed to find Product with ID: #{request.message.id}")
  end

  def get_products
    return enum_for(:get_products) unless block_given?
    products = ::Product.all
    products.each do |product|
      yield product.to_proto
    end
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace)
    fail!(:internal, :unknown, "Unknown error when listing products: #{e.message}")
  end

  def create_products
    products = []
    request.messages do |message|
      products << Product.create(name: message.name, stock: message.stock).to_proto
    end
    Pim::CreateProductsResp.new(products: products)
  end

  def create_products_in_stream
    request.messages.each do |r|
      yield Product.create(name: r.name, stock: r.stock).to_proto
    end
  end
end