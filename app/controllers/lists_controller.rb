class ListsController < ApplicationController
  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @books = @list.books
  end

  def create
    @list = List.new(name: list_params[:name], description: list_params[:description])
    @list.user = current_user
    @book = Book.find_by(googlebooks_id: list_params[:googlebooks_id])
    if @list.save
      @listbook = ListBook.create(book: @book, list: @list)
      redirect_to list_path(@list)
    else
      render template: "books/show", status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require("list").permit(:name, :description, :googlebooks_id)
  end
end
