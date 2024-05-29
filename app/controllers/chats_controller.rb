class ChatsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_application

    def create_response(object)
      render :json => object, :except => [:id, :application_id], status: :ok
    end
    
    def create
        chat = @application.chats.new(number: chat_number)
        chat_number = @application.chats_count + 1
    
        if chat.save
          @application.increment!(:chats_count)
          create_response chat
        else
          render json: chat.errors, status: :unprocessable_entity
        end
      end
    
      def show
        chat = @application.chats.find_by!(number: params[:number])
        create_response chat
      end

      def update
        chat = @application.chats.find_by!(number: params[:number])
        if chat.update(chat_params)
          create_response chat
        else
          render json: chat.errors, status: :unprocessable_entity
        end
      end

      def index
        chats = @application.chats
        render json: chats
      end

      private

      def set_application
        @application = Application.find_by!(token: params[:application_token])
      end

      def chat_params
        params.require(:chat).permit(:name)
      end
end
