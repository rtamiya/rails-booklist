class Book < ApplicationRecord
  has_many :book_lists
  validates :title, presence: true
end
