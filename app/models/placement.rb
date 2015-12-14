class Placement < ActiveRecord::Base
  attr_reader :placement_time

  belongs_to :refugee
  belongs_to :home
  belongs_to :moved_out_reason

  validates_presence_of :home

  before_validation do
    if moved_out_at.present? && moved_in_at > moved_out_at
      errors.add :moved_out_at, 'måste vara senare än inskrivningen'
    end
  end

  def placement_time
    if moved_out_at.present?
      diff = moved_out_at - moved_in_at
    else
      diff = DateTime.now.to_date - moved_in_at
    end
    diff.to_i
  end
end
