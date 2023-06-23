require 'open-uri'

class BooksController < ApplicationController
  def show
    if Book.find_by(googlebooks_id: params[:googlebooks_id]).nil?
      @book = Book.new
      url = "https://www.googleapis.com/books/v1/volumes/#{params[:googlebooks_id]}"
      book_info = JSON.parse(URI.open(url).read)
      @book.googlebooks_id = book_info["id"] unless book_info["id"].nil?
      @book.googlebooks_link = book_info["selfLink"] unless book_info["selfLink"].nil?
      @book.title = book_info["volumeInfo"]["title"] unless book_info["volumeInfo"]["title"].nil?
      @book.subtitle = book_info["volumeInfo"]["subtitle"] unless book_info["volumeInfo"]["subtitle"].nil?
      @book.author = book_info["volumeInfo"]["authors"][0] unless book_info["volumeInfo"]["authors"].nil?
      @book.publisher = book_info["volumeInfo"]["publisher"] unless book_info["volumeInfo"]["publisher"].nil?
      @book.published_date = book_info["volumeInfo"]["publishedDate"] unless book_info["volumeInfo"]["publishedDate"].nil?
      @book.description = book_info["volumeInfo"]["description"] unless book_info["volumeInfo"]["description"].nil?
      @book.page_count = book_info["volumeInfo"]["pageCount"] unless book_info["volumeInfo"]["pageCount"].nil?
      @book.categories = book_info["volumeInfo"]["categories"][0] unless book_info["volumeInfo"]["categories"].nil?
      @book.language = book_info["volumeInfo"]["language"] unless book_info["volumeInfo"]["language"].nil?
      @book.image_link = book_info["volumeInfo"]["imageLinks"]["thumbnail"] unless book_info["volumeInfo"]["imageLinks"].nil?
      @book.save
    else
      @book = Book.find_by(googlebooks_id: params[:googlebooks_id])
    end
  end
end
