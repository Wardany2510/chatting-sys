class MessageJob
  include Sidekiq::Worker
  queue_as :default
  def perform((body, chat_id, number)
    chat = Chat.find(chat_id)
    message = Message.new(body: body, chat_id: chat_id, number: number)
    message.save
    Message.reindex()
  end 

 
end
