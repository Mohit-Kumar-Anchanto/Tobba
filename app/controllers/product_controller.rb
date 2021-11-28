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

  # def start_connection
  #   bunny_connection = Bunny.new
  #   bunny_connection.start
  # end

  # def connect_channel
  #   channel = bunny_connection.create_channel
  # end

  def get_payload(queue_name)
    @bunny_connection.start
    channel = @bunny_connection.create_channel
    #channel = connect_channel
    queue  = channel.queue(queue_name, :auto_delete => true)
    #ap queue.name
    queue.subscribe do |delivery_info, metadata, payload|
      puts "Received #{payload}"
      create_product(payload)
    end
  end

  def send_request_to_create_order(order_number, price, queue_name)
    @bunny_connection.start
    channel = @bunny_connection.create_channel
    exchanger = channel.default_exchange
    payload = { number: order_number, price: price}
    exchanger.publish(payload.to_json, :routing_key => queue_name)
    @bunny_connection.close
  end

end
