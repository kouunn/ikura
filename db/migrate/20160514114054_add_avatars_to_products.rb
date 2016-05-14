class AddAvatarsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :avatars, :json
  end
end
