class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: true
      t.string :last_name,  null: true
      t.string :password_digest, null: false
      t.integer :type_of_user, null: false
    end
  end
end
