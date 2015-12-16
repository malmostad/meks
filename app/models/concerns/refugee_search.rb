module RefugeeSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings Rails.application.config.elasticsearch

    # Override model name
    index_name "refugees_#{Rails.env}"
    document_type "refugee"

    mappings dynamic: 'false' do
      indexes :name, analyzer: 'simple'
      indexes :name_phrase, analyzer: "simple"
      # indexes :name_search, index_analyzer: 'name_index', search_analyzer: 'name_search'
      indexes :ssns, analyzer: 'simple'
      indexes :dossier_numbers, analyzer: 'simple'
    end
  end

  def as_indexed_json(options={})
    {
      id: id,
      name: name,
      name_phrase: name,
      # name_search: name,
      ssns: ssns.map(&:name),
      dossier_numbers: dossier_numbers.map(&:name),
    }.as_json
  end

  module ClassMethods
    def fuzzy_search(query, options = {})
      return false if query.blank?
      settings = {
        from: 0, size: 10
      }.merge(options)
      begin
        response = __elasticsearch__.search fuzzy_query(query, settings[:from], settings[:size])

        { refugees: response.records.to_a, # to_a is needed to be able to serialize for memcached
          total: response.results.total,
          took: response.took
        }
      rescue Exception => e
        logger.error "Elasticsearch: #{e}"
        false
      end
    end

    def fuzzy_suggest(query)
      begin
        response = __elasticsearch__.search fuzzy_query(query, 0, 10)
        response.map(&:_source)
      rescue Exception => e
        logger.error "Elasticsearch: #{e}"
        false
      end
    end

  private

    def fuzzy_query(query, from, size)
      query = sanitize_query(query)
      {
        from: from,
        size: size,
        query: {
          bool: {
            should: [
              { # very fuzzy
                match: {
                  name: {
                    query: query,
                    fuzziness: 2,
                    prefix_length: 0
                  }
                }
              },
              { # boost exact match
                match: {
                  name: {
                    boost: 5,
                    query: query
                  }
                }
              },
              { # boost exact phrase
                match_phrase_prefix: {
                  name_phrase: {
                    boost: 10,
                    query: query
                  }
                }
              },
              {
                match: {
                  name_search: {
                    query: query,
                    prefix_length: 0
                  }
                }
              },
              {
                multi_match: {
                  fields: [
                    "ssns",
                    "dossier_numbers"
                  ],
                  query: query
                }
              }
            ]
          }
        }
      }
    end

    # NOTE: The sanitizer does not allow grouping and operators in the query
    def sanitize_query(query)
      # Remove Lucene reserved characters
      query.gsub!(/([#{Regexp.escape('\\+-&|!(){}[]^~*?:/"\'')}])/, '')

      # Remove Lucene operators
      query.gsub!(/\s+\b(AND|OR|NOT)\b/i, '')
      query
    end
  end
end
