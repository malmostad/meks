module RefugeeSelections
  extend ActiveSupport::Concern
  DEFAULT_RANGE = { from: Date.new(0), to: Date.today }.freeze

  module ClassMethods
    def per_type_of_housing(type_of_housing, registered = DEFAULT_RANGE)
      includes(:payments, placements: { home: :type_of_housings })
        .where(placements: { home: { type_of_housings: { id: type_of_housing.id } } })
        .where(registered: registered[:from]..registered[:to])
    end
  end

  included do
  end
end
