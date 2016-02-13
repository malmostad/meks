module RefugeeSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    settings Rails.application.config.elasticsearch

    # Override model name
    index_name "refugees_#{Rails.env}"
    document_type 'refugee'

    after_save do
      __elasticsearch__.index_document
    end

    after_destroy do
      delete_document
    end

    mappings dynamic: 'false' do
      indexes :name, analyzer: 'simple'
      indexes :name_phrase, analyzer: 'simple'
      indexes :name_search, analyzer: 'name_index', search_analyzer: 'name_search'
      indexes :ssn, analyzer: 'nmbr', search_analyzer: 'standard'
      indexes :ssns, analyzer: 'nmbr', search_analyzer: 'standard'
      indexes :dossier_number, analyzer: 'nmbr', search_analyzer: 'standard'
      indexes :dossier_numbers, analyzer: 'simple' #, search_analyzer: 'standard'
    end

    def delete_document
      # ES document might already be deleted, so we do not log errors unless debug
      begin
        __elasticsearch__.delete_document
      rescue Exception => e
        logger.debug { "Document could not be deleted: #{e}" }
      end
    end
  end

  def as_indexed_json(options={})
    {
      id: id,
      name: name,
      name_phrase: name,
      name_search: name,
      ssn: ssn,
      ssns: ssns.map(&:full_ssn).join(' '),
      dossier_number: dossier_number,
      dossier_numbers: dossier_numbers.map(&:name).join(' ')
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

        { refugees: response.records.includes(
            :countries, :gender, :placements, :homes).to_a,
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
      {
        from: from,
        size: size,
        query: {
          bool: {
            should: [
              { # very fuzzy
                match: {
                  name_search: {
                    query: query,
                    fuzziness: 2,
                    prefix_length: 0
                  }
                }
              },
              { # boost exact match
                match: {
                  name_search: {
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
                  name: {
                    query: query,
                    prefix_length: 0
                  }
                }
              },
              {
                match: {
                  ssn: {
                    boost: 10,
                    query: query
                  }
                }
              },
              {
                match: {
                  ssns: {
                    boost: 5,
                    query: query
                  }
                }
              },
              {
                match: {
                  dossier_number: {
                    boost: 10,
                    query: query
                  }
                }
              },
              {
                match: {
                  dossier_numbers: {
                    boost: 5,
                    query: query
                  }
                }
              }
            ]
          }
        }
      }
    end
  end
end
