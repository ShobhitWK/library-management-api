class CreateIssuedbooks < ActiveRecord::Migration[6.1]
  def change
    create_table :issuedbooks do |t|
      t.integer :user_id
      t.integer :book_id
      t.boolean :is_returned
      t.datetime :return_dt
      t.timestamps
    end
  end
end
