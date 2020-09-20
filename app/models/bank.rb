class Bank < ApplicationRecord
  validates :name, presence: true
  has_many :report_datum, dependent: :destroy
end
