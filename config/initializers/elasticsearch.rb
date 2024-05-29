Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'
)

Rails.application.config.to_prepare do
    Message.__elasticsearch__.create_index! force: true unless Message.__elasticsearch__.index_exists?
    Message.import
  end