class Api::V1::ChatsController < ApplicationController
    before_action :set_application
    before_action :set_chat, only: [ :show ,:update ,:destroy ]

    def index
        @chats = @application.chats
        render json: @chats;
    end

    def show
        render json: {status: :ok, error: '', data: {
            chat_number: @chat.chat_number
        }}, status: :ok
    end
    def create
        CreateChatWorker.perform_async(@application.id, get_new_chat_number)
        render json: {status: :created, error: '', data: {chat_number: get_new_chat_number}}, status: :created
    end

    def update
        render json: {status: :not_found, error: 'Not Found', data: []}, status: :not_found
    end
    def destroy
        render json: {status: :not_found, error: 'Not Found', data: []}, status: :not_found
    end

    private
        def set_chat
            @chat = @application.chats.find_by(chat_number: params[:chat_number])
        end
        def get_new_chat_number
            redis= RedisService.new()
            number = redis.get_from_redis("application_#{@application.token}_chat_number")
            if !number
                number = redis.await.save_in_redis("application_#{@application.token}_chat_number",1)
            else
                number = redis.await.increment_counter("application_#{@application.token}_chat_number")
            end 

           number.value
        end
        
        def chat_params
             params.require(:chat).permit()
        end
        def set_application
             @application = Application.find_by(token: params[:application_token])
        end
end