module RefugeeSelections
  extend ActiveSupport::Concern

  module ClassMethods
    def per_type_of_housing(type_of_housing, registered = default_date_range)
      includes(:payments, placements: { home: [:type_of_housings, :costs] })
        .where(placements: { home: { type_of_housings: { id: type_of_housing.id } } })
        .where(registered: registered[:from]..registered[:to])
    end
  end

  included do
  end
end
