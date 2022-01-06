class PublisherService 
  
  attr_accessor :new_connection, :channel
  def initialize
    @new_connection = BaseService.new
    @new_connection.start
    @channel = @new_connection.create_channel
    puts "Publisher Channel Created"
  end

  #Declaring a queue is idempotent - it will only be created if it doesn't exist already
  # durable: true make sures that queue will survive a RabbitMQ node restart
  #Exclusive (used by only one connection and the queue will be deleted when that connection closes)
  def declare_queue(queue_name = "default", durable = true)
    puts "A queue with name #{queue_name} declared"
    @channel.queue(queue_name, durable: durable)
  end

  # persistent: true it tells RabbitMQ to save the message to disk
  def publish_message(routing_key, msg, persistent = false, correlation_id = "a_secret_key")
    puts " Message sent #{msg}"
    @channel.default_exchange.publish(msg, routing_key: routing_key, persistent: persistent, correlation_id: correlation_id )
  end

  def close_connection
    puts "Connections Closed"
    @new_connection.close  
  end

end
