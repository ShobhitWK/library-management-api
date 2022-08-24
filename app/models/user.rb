class User < ApplicationRecord

  # Before saving a email this will downcase the emaill
  before_save { self.email = email.downcase}

  # Associations
  has_many :books, dependent: :destroy
  belongs_to :role
  has_many :issuedbooks, dependent: :destroy

  # Devise Configurations
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

  # Validations for user email and name
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, presence: true,
                        length: {minimum: 5, maxmimum: 105},
                        uniqueness: {case_sensitive: false},
                        format: { with: VALID_EMAIL_REGEX }

  validates :address, presence: true,
                        length: {minimum: 7, maximum: 300}

  validates :name, presence: true,
                        length: {minimum: 3}

end
