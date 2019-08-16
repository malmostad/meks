module PersonSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def fuzzy_search(query, options = {})
      return false if query.blank?

      settings = {
        from: 0, size: 10
      }.merge(options)

      begin
        response = __elasticsearch__.search fuzzy_query(query, settings[:from], settings[:size])

        { people: response.records.includes(
            :countries, :gender, current_placements: [:home]).to_a,
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
              },
              {
                match: {
                  procapita: {
                    boost: 10,
                    query: query
                  }
                }
              },
            ]
          }
        }
      }
    end
  end
end
