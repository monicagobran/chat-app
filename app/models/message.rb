class Message < ApplicationRecord
  include Searchable
  
  belongs_to :chat
  validates :number, presence: true, uniqueness: { scope: :chat_id }
end
