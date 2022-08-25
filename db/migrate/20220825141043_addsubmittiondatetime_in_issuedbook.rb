class AddsubmittiondatetimeInIssuedbook < ActiveRecord::Migration[6.1]
  def change
    add_column :issuedbooks, :submittion, :datetime
  end
end
