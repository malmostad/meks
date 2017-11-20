class AddSocialWorkerToRefugee < ActiveRecord::Migration[4.2]
  def change
    add_column :refugees, :social_worker, :text
  end
end
