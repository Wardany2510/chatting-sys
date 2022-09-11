class Api::V1::MessagesController < ApplicationController
    before_action :set_app
    before_action :set_chat
    before_action :set_message, only: [:show, :update, :destroy]

    def index
        @messages = @chat.messages
        render json: {status: :ok, error: '', data: @messages}, status: :ok
    end
    def create
        CreateChatWorker.perform_async(@@chat.id, get_new_message_number)
        render json: {status: :created, error: '', data: {message_number: get_new_chat_number}}, status: :created
    end
    def show
        render json: {status: :ok, error: '', data: {
            number: @message.number, message: @message.body
        }}, status: :ok
    end
    def search 
        @messages= Message.partial_search(params['query'],@chat).records
        render json: @messages 
    end

    def update
        if message_params[:body] && !message_params[:body].empty?
            UpdateMessageWorker.perform_async(@message.id, params[:body])
            render json: {status: :ok, error: '', data: {number: @message.number}}, status: :ok
        else
            render json: {status: :unprocessable_entity, error: 'invalid message', data: []}, status: :unprocessable_entity
        end
    end
    private
        def set_application
            @application = Application.find_by(token: params[:application_token])
        end
        def set_chat
            @chat = @application.chats.find_by(number: params[:chat_number])
        end
        def set_message
            @message = @chat.messages.find_by(number: params[:number])
        end
        def message_params
            params.require(:body).permit(:body)
        end 
        def get_new_message_number
            redis= RedisService.new()
            number = redis.get_from_redis("app_#{@application.token}_chat#{@chat.number}_message_ready_number")
            if !number
                redis.await.save_in_redis("app_#{@application.token}_chat#{@chat.number}_message_ready_number",1)
            end 
            redis.await.increment_counter("app_#{@application.token}_chat#{@chat.number}_message_ready_number")
            number.value
        end


end