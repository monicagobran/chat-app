class MessagesController < ApplicationController
    protect_from_forgery with: :null_session
    include Elasticsearch::Model
    before_action :set_chat

    def create_response(object)
      render :json => object, :except => [:id, :application_id, :chat_id], status: :ok
    end

    def create
        message_params = params.require(:message).permit(:body).to_h
        message_json = message_params.to_json
        message_number = $redis.incr("chat:#{@chat.id}:messages_count")
        MessageCreationWorker.perform_async(@application.token, @chat.number, message_number, message_json)
        render json: { message_number: message_number }, status: :accepted
      rescue StandardError => e
        $redis.decr("chat:#{@chat.id}:messages_count")
        raise e
      end
    
      def show
        message = @chat.messages.find_by!(number: params[:number])
        create_response message
      end

      def search
          results = Message.search(params[:query], @chat.id)
          create_response results.records
      end

      def update
        message = @chat.messages.find_by!(number: params[:number])
        if message.update(message_params)
          create_response message
        else
          render json: message.errors, status: :unprocessable_entity
        end
      end

      def index
        messages = @chat.messages
        create_response messages
      end
    
      private

      def set_chat
        @application = Application.find_by!(token: params[:application_token])
        @chat = @application.chats.find_by!(number: params[:chat_number])
      end
    
      def message_params
        params.require(:message).permit(:body)
      end

end
