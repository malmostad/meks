class CreateOneTimePayment < ActiveRecord::Migration[5.2]
  def change
    create_table :one_time_payments do |t|
      t.integer :amount
      t.date :start_date
      t.date :end_date
    end
  end
end
