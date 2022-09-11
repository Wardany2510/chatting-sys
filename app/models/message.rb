require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :body, presence: true
  belongs_to :chat

    def as_json(options={})
      {
        :body => body,
        :number => number,
      }
    end
    def self.partial_search(q,chat)
      q = "*#{q}*"
      __elasticsearch__.search({
        "query": {
          "bool": {
            "must": {
              "wildcard": { "body": q }
            },
            "filter": {
              "term": { "chat_id": chat.id }
            }
          }
        }
      })
    end

end
  