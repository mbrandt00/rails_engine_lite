class AddRelationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :merchant, foreign_key: true
    add_reference :users, :customer, foreign_key: true
  end
end
