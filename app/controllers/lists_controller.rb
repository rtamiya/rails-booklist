require 'open-uri'

class ListsController < ApplicationController
  def index
    @lists = List.all
    @list = List.new
    @list_book = ListBook.new
  end

  def show
    @list = List.find(params[:id])
    @books = @list.books
  end

  def create
    @list = List.new(name: list_params[:name], description: list_params[:description])
    @list.user = current_user

    if params[:googlebooks_ids].nil?
      @book = Book.find_by(googlebooks_id: list_params[:googlebooks_id])
      if @list.save
        @list_book = ListBook.create(book: @book, list: @list)
        redirect_to list_path(@list)
      else
        @list_book = ListBook.new
        @lists = List.all
        render template: "books/show", status: :unprocessable_entity
      end
    elsif params[:googlebooks_ids].empty?
      @list_book = ListBook.new
      @lists = List.all
      render template: "lists/index", status: :unprocessable_entity
    else
      googlebooks_ids = JSON.parse(params[:googlebooks_ids])
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
      if @list.save
        @books.each do |book|
          @list_book = ListBook.create(book:, list: @list)
        end
        redirect_to list_path(@list)
      else
        @list_book = ListBook.new
        @lists = List.all
        render template: "lists/index", status: :unprocessable_entity
      end
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to root_path
  end

  private

  def list_params
    params.require(:list).permit(:name, :description, :googlebooks_id)
  end
end
