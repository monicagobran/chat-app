module Searchable
    extend ActiveSupport::Concern
  
    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
  
      settings do
        mappings dynamic: 'false' do
          indexes :body, type: :text
          indexes :chat_id, type: :integer
        end
      end
  
      def as_indexed_json(options = {})
        as_json(only: [:body, :chat_id])
      end

      def self.search(query, id)
        params = {
            query: {
                bool: {
                  must: [
                    {
                      match: {
                        body: {
                          query: query,
                          fuzziness: 'AUTO'
                        }
                      }
                    },
                    {
                      term: { chat_id: id }
                    }
                  ]
                }
            }
      }

      self.__elasticsearch__.search(params)
      end
    end
  end

