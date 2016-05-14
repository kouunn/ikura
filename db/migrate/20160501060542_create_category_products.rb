class CreateCategoryProducts < ActiveRecord::Migration
  def change
    create_table :category_products do |t|
      t.integer :category_id
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
