class ProductController < ApplicationController

  def self.create_product(payload)
    payload = JSON.parse(payload)
    product_name = payload["name"]
    stock = payload["stock"]
    Product.find_or_create_by(name: product_name, stock: stock)
  end

  def self.get_payload
    consumer = ConsumerService.new
    queue = consumer.declare_queue("CreateProduct")
    payload = consumer.consume_message(queue)
    puts "Payload Received #{payload}"
    ProductController.create_product(payload) if payload.present?
    return false
  end

  def self.send_request_to_create_order(order_number, price)
    publisher = PublisherService.new
    queue = publisher.declare_queue("CreateOrder")
    payload = { number: order_number, price: price}
    payload = payload.to_json
    publisher.publish_message(queue.name, payload)
    publisher.close_connection
  end

end
