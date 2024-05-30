class MessagesController < ApplicationController
    protect_from_forgery with: :null_session
    include Elasticsearch::Model
    before_action :set_chat

    def create_response(object)
      render :json => object, :except => [:id, :application_id, :chat_id], status: :ok
    end

    def create
        message = @chat.messages.new(number: message_number, body: message_params[:body])
        message_number = @chat.messages_count + 1
        
    
        if message.save
          @chat.increment!(:messages_count)
          create_response message
        else
          render json: message.errors, status: :unprocessable_entity
        end
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
        application = Application.find_by!(token: params[:application_token])
        @chat = application.chats.find_by!(number: params[:chat_number])
      end
    
      def message_params
        params.require(:message).permit(:body)
      end

end
