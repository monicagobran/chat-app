class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages
  validates :number, presence: true, uniqueness: { scope: :application_id }
  after_initialize :set_defaults, unless: :persisted?

  private

  def set_defaults
    self.messages_count ||= 0
  end
end
