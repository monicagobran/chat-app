class Application < ApplicationRecord
    has_many :chats
    validates :name, presence: true
    before_create :generate_token
    after_initialize :set_defaults
  
    # TODO: check not already exists
    private
    def generate_token
      self.token = SecureRandom.hex(10)
    end

    private
    def set_defaults
        self.chats_count ||= 0
    end
end
