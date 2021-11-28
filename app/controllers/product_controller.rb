class ProductController < ApplicationController

  def initialize
    @bunny_connection = Bunny.new
  end

  def create_product(payload)
    payload = JSON.parse(payload)
    product_name = payload["name"]
    stock = payload["stock"]
    Product.find_or_create_by(name: product_name, stock: stock)
  end

  def get_payload
    consumer = ConsumerServices.new
    queue = consumer.declare_queue("CreateProduct")
    payload = consumer.consume_message(queue)
    create_product(payload) if payload.present?
    return false
  end

  def send_request_to_create_order(order_number, price)
    publisher = PublisherServices.new
    queue = publisher.declare_queue("CreateOrder")
    payload = { number: order_number, price: price}
    payload = payload.to_json
    publisher.publish_message(payload, queue.name)
    publisher.close_connection
  end

end
