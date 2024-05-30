class MessageCreationWorker
    include Sidekiq::Worker
  
    def perform(application_token, chat_number, message_number, message_json)
      application = Application.find_by!(token: application_token)
      chat = application.chats.find_by!(number: chat_number)
      message = chat.messages.create!(number: message_number, body: JSON.parse(message_json)["body"])
      chat.increment!(:messages_count)
    end
  end