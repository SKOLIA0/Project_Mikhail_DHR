class User < ApplicationRecord
  has_and_belongs_to_many :interests, dependent: :destroy
  has_and_belongs_to_many :skills, dependent: :destroy

  validates :name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
