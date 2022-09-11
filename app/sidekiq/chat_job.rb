class ChatJob
  include Sidekiq::Worker
  queue_as :default
  def perform(app_token,number)
    app = Application.find(app_token)
    chat = Chat.new(application_id: app.id, chat_number: number)
    chat.save
  end 

 
end
