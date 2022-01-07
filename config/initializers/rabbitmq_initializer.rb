class RabbitQueueService
  def self.logger
    Rails.logger.tagged('bunny') do
      @@_logger ||= Rails.logger
    end
  end

  def self.connection
    @@_connection ||= begin
      instance = Bunny.new(
        # addresses: ENV['BUNNY_AMQP_ADDRESSES'].split(','),
        # username:  ENV['BUNNY_AMQP_USER'],
        # password:  ENV['BUNNY_AMQP_PASSWORD'],
        # vhost:     ENV['BUNNY_AMQP_VHOST'],
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: (ENV['BUNNY_CONTINUATION_TIMEOUT'] || 10_000).to_i,
        logger: RabbitQueueService.logger
      )
      instance.start
      instance
    end
  end

end
