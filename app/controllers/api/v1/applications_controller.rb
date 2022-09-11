require 'securerandom'

class Api::V1::ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update, :destroy]

    def index
        @applications = Application.paginate(page: params[:page],per_page: 10)
        render json: @applications;
    end

    def create
        @application = Application.new({
            name: params[:name],
            token: generate_token
        })

        if @application.save!
            render json: @application
         else
            render json: @application.errors, status: :unprocessable_entity
        end
    end
    def show
        render json: @application
      end

    def update
        if @application.update(application_params)
            render json: @application ,status: :ok
        else
          render json: @application.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @application.destroy
      end

    private
    def generate_token
        loop do
          token = SecureRandom.uuid
          break token unless Application.where(token: token).exists?
        end
    end

    def set_application
        @application = Application.find_by(token: params[:token])
    end
  
    def application_params
        params.require(:application).permit(:name)
    end


end