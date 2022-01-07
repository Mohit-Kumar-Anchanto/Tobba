class OmsService
  def initialize(type, method, orders=nil)
    @orders = orders
    @type = type
    @method = method
  end

  def call
    send("#{@type}_#{@method}")
  end

  def grpc_create_products
    return unless @orders.present?

    request_object = []
    @orders.each do |order|
      request_object << Oms::Order.new(number: order[:number], total: order[:total])
    end
    reponse = oms_grpc_client.call(:CreateOrders, request_object)
    puts response.message.inspect
  rescue Gruf::Client::Error => e
    puts e.error.inspect
  end

  def grpc_get_products
    response = oms_grpc_client.call(:GetOrders)
    puts response.message.inspect
  rescue Gruf::Client::Error => e
    puts e.error.inspect
  end

  def bunny

  end


  private

  def oms_grpc_client
    ::Gruf::Client.new(options: {hostname: '0.0.0.0:10541'}, service: ::Oms::Orders)
  end
end
