class List < ApplicationRecord
  belongs_to :user
  has_many :list_books

  has_many :books, through: :list_books

  validates :name, presence: true
end
