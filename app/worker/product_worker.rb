require 'sneakers'

class ProductWorker
  include Sneakers::Worker
  from_queue :CreateProduct

  def work(msg)
    p msg
    CreateProductJob.perform(msg)
    ack!
  end

end
