class AddSocialWorkerToRefugee < ActiveRecord::Migration
  def change
    add_column :refugees, :social_worker, :text
  end
end
