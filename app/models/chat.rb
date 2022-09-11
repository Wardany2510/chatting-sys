class Chat < ApplicationRecord
    belongs_to :application

    def as_json(options={})
    {
      :chat_number => chat_number,
      :number => number,
    }
  end

end
  