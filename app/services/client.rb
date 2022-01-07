class Client
  attr_accessor :call_id, :lock, :condition, :reply_queue, :exchange, :params, :response, :server_queue_name, :channel, :reply_queue_name

  def initialize
    @channel = channel
    @exchange = channel.default_exchange
    @server_queue_name = "CreateProduct"
    @reply_queue_name = "ReplyCreateProduct"
    @params = {}
    setup_reply_queue
  end

  def setup_reply_queue
    @lock = Mutex.new
    @condition = ConditionVariable.new
    that = self
    @reply_queue = channel.queue(reply_queue_name, durable: true)

    reply_queue.subscribe do |_delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload
        that.lock.synchronize { that.condition.signal }
      end
    end
  end

  def call
    @call_id = "NAIVE_RAND_#{rand}#{rand}#{rand}"
    exchange.publish(params.to_json,
                     routing_key: server_queue_name,
                     correlation_id: call_id,
                     reply_to: reply_queue.name)
    lock.synchronize { condition.wait(lock) }
    connection.close
    response
  end

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    @connection ||= Bunny.new.tap { |c| c.start }
  end
end
