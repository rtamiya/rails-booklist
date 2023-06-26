class ListBooksController < ApplicationController
  def create
    @list_book = ListBook.new
    @list_book.list = List.find(list_book_params[:list])
    @list_book.book = Book.find(list_book_params[:book])
    if @list_book.save
      redirect_to list_path(@list_book.list)
    else
      render template: "books/show", status: :unprocessable_entity
    end
  end

  private

  def list_book_params
    params.require(:list_book).permit(:list, :book)
  end
end