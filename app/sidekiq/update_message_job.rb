class UpdateMessageJob
  include Sidekiq::Worker
  queue_as :default
  def perform((message_id , body)
    Message.where(id: message_id).update(body: body)
    Message.reindex()
  end 
end
