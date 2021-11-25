class ProductController < ApplicationController

  def create_product(payload)
    product_name = payload["product_name"]
    stock = payload["stock"]
    Product.find_or_create_by(name: product_name, stock: stock)
  end

  def connect_channel(queue_name)
    bunny_connection = Bunny.new
    bunny_connection.start
    channel = bunny_connection.create_channel
    queue  = channel.queue(queue_name, :auto_delete => true)
  end

  def get_payload(queue_name)
    queue = connect_channel(queue_name)
    q.subscribe do |delivery_info, metadata, payload|
      ap "Received #{payload}"
      create_product(payload)
    end
  end

  def send_request_to_create_order(order_number, price, queue_name)
    order_conn = Bunny.new
    order_conn.start
    channel = order_conn.create_channel
    exchanger = channel.default_exchange
    payload = { number: order_number, price: price}
    exchanger.publish(payload, :routing_key => queue_name)
  end

end
