class AddFineInIssuedbook < ActiveRecord::Migration[6.1]
  def change
    add_column :issuedbooks, :issued_on, :datetime
    add_column :issuedbooks, :fine, :float
  end
end
