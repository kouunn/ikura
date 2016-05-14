class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name_cn
      t.string :name_jp
      t.integer :price
      t.text :introduction
      t.string :pic_url

      t.timestamps null: false
    end
  end
end
