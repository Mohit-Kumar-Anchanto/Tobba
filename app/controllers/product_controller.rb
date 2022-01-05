class ProductController < ApplicationController

  def self.send_request_to_create_order(order_number, price)
    publisher = PublisherService.new
    queue = publisher.declare_queue("CreateOrder")
    payload = { number: order_number, price: price}
    payload = payload.to_json
    publisher.publish_message(queue.name, payload)
    publisher.close_connection
  end

end
