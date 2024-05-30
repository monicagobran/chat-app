class ChatCreationWorker
    include Sidekiq::Worker
  
    def perform(application_token, chat_number)
      application = Application.find_by!(token: application_token)
      application.chats.create!(number: chat_number)
      application.increment!(:chats_count)
    end
  end