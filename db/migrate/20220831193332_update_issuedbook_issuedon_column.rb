class UpdateIssuedbookIssuedonColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :issuedbooks, :return_dt, :date
    change_column :issuedbooks, :issued_on, :date
    change_column :issuedbooks, :submittion, :date
  end
end
