class BooksController < ApplicationController
  def show
    @book = Book.find_by(googlebooks_id: params[:googlebooks_id])
  end
end
