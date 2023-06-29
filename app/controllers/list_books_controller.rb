require 'open-uri'

class ListBooksController < ApplicationController
  def create
    if params[:googlebooks_ids_for_list_book].nil?
      create_list_book
    else
      create_list_books
    end
  end

  def destroy
    @list_book = ListBook.find(params[:id])
    @list = @list_book.list
    @list_book.destroy
    redirect_to list_path(@list)
  end

  private

  def list_book_params
    params.require(:list_book).permit(:list, :book)
  end

  def create_list_book
    @list_book = ListBook.new
    @book = Book.find(list_book_params[:book])
    @list = List.find(list_book_params[:list])
    @list_book.list = @list
    @list_book.book = @book
    if @list_book.save
      redirect_to list_path(@list_book.list)
    else
      render template: "books/show", status: :unprocessable_entity
    end
  end

  def create_list_books
    @list = List.find(list_book_params[:list])
    googlebooks_ids = JSON.parse(params[:googlebooks_ids_for_list_book])
    @books = googlebooks_ids.map do |googlebooks_id|
      if Book.find_by(googlebooks_id: googlebooks_id).nil?
        book = Book.new
        url = "https://www.googleapis.com/books/v1/volumes/#{googlebooks_id}"
        book_info = JSON.parse(URI.open(url).read)
        book.googlebooks_id = book_info["id"] unless book_info["id"].nil?
        book.googlebooks_link = book_info["selfLink"] unless book_info["selfLink"].nil?
        book.title = book_info["volumeInfo"]["title"] unless book_info["volumeInfo"]["title"].nil?
        book.subtitle = book_info["volumeInfo"]["subtitle"] unless book_info["volumeInfo"]["subtitle"].nil?
        book.author = book_info["volumeInfo"]["authors"][0] unless book_info["volumeInfo"]["authors"].nil?
        book.publisher = book_info["volumeInfo"]["publisher"] unless book_info["volumeInfo"]["publisher"].nil?
        book.published_date = book_info["volumeInfo"]["publishedDate"] unless book_info["volumeInfo"]["publishedDate"].nil?
        book.description = book_info["volumeInfo"]["description"] unless book_info["volumeInfo"]["description"].nil?
        book.page_count = book_info["volumeInfo"]["pageCount"] unless book_info["volumeInfo"]["pageCount"].nil?
        book.categories = book_info["volumeInfo"]["categories"][0] unless book_info["volumeInfo"]["categories"].nil?
        book.language = book_info["volumeInfo"]["language"] unless book_info["volumeInfo"]["language"].nil?
        book.image_link = book_info["volumeInfo"]["imageLinks"]["thumbnail"] unless book_info["volumeInfo"]["imageLinks"].nil?
        book.save
        book
      else
        Book.find_by(googlebooks_id:)
      end
    end
    @books.each do |abook|
      @list_book = ListBook.new
      @list_book.list = @list
      @list_book.book = abook
      @list_book.save
    end
    redirect_to list_path(@list)
  end
end
