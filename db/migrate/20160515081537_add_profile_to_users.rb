#rails g migration add_profile_to_users user_name:string icon:string sex:boolean birthday:date contact:string introduction:text
class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :icon, :string
    add_column :users, :sex, :boolean
    add_column :users, :birthday, :date
    add_column :users, :contact, :string
    add_column :users, :introduction, :text
  end
end
