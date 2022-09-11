class Application < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  has_many :chats, dependent: :destroy

    def as_json(options={})
    {
      :name => name,
      :token => token,
      :chat_count => chats_count,
    }
  end
end
