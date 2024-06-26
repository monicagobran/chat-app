class ChatsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_application

    def create_response(object)
      render :json => object, :except => [:id, :application_id], status: :ok
    end
    
    def create
        chat_number = $redis.incr("application:#{@application.id}:chats_count")
        ChatCreationWorker.perform_async(@application.token, chat_number)
        render json: { chat_number: chat_number }, status: :accepted
    rescue StandardError => e
      $redis.decr("application:#{@application.id}:chats_count")
      raise e
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
        create_response chats
      end

      private

      def set_application
        @application = Application.find_by!(token: params[:application_token])
      end

      def chat_params
        params.require(:chat).permit(:name)
      end
end
