require 'sneakers'
require 'sneakers/runner'
require 'byebug'
require 'oj'

class TestSyncWorker
  include Sneakers::Worker
  from_queue 'CreateProd', durable: true

  def work_with_params(deserialized_msg, delivery_info, metadata)
    post = {name: "Hello Mohit"}
    
    # p = publish(post.to_json, {      
    #           to_queue: metadata[:reply_to],
    #           correlation_id: metadata[:correlation_id],
    #           content_type: metadata[:content_type]
    #         })

      
    # byebug
    PL_LOG.info "Got the request data ==> #{JSON.parse(deserialized_msg)} sending the response to #{metadata[:reply_to]} with secert key #{metadata[:correlation_id]}"
    send_response(post, metadata[:reply_to], metadata[:correlation_id])
    ack!
  end

  def send_response(params, reply_queue, correlation_id)
    publisher = PublisherService.new
    queue = publisher.declare_queue(reply_queue)
    payload = params
    PL_LOG.info "Sending the response #{payload}"
    payload = payload.to_json
    publisher.publish_message(reply_queue, payload, false, correlation_id)
    publisher.close_connection
  end
end


#Now use it to solve the 
