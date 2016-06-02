module RefugeeIndex
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    settings Rails.application.config.elasticsearch

    # Override model name
    index_name "refugees_#{Rails.env}"
    document_type 'refugee'

    after_commit do
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
      indexes :ssns, analyzer: 'nmbr_letters', search_analyzer: 'standard'
      indexes :dossier_number, analyzer: 'nmbr', search_analyzer: 'standard'
      indexes :dossier_numbers, analyzer: 'nmbr_letters', search_analyzer: 'standard'
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
end
