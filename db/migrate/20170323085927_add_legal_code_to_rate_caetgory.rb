class AddLegalCodeToRateCaetgory < ActiveRecord::Migration[5.0]
  def change
    add_reference :rate_categories, :legal_code, index: true, foreign_key: true
  end
end
