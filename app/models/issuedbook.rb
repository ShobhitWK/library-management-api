class Issuedbook < ApplicationRecord
  
  # Associations
  belongs_to :book
  belongs_to :user

  # validations

  validates :user_id, presence: true
  validates :book_id, presence: true
  validates :issued_on, presence: true
  validates :user_id, presence: true
  validates :fine, presence: true

end
