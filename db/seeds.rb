# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'
require 'open-uri'

ListBook.destroy_all
Book.destroy_all
List.destroy_all
User.destroy_all

puts "creating users..."

User.create!(
  email: "ryo@mail.com",
  password: "password"
)

User.create!(
  email: "oliver@mail.com",
  password: "password"
)

user = User.first

# create array of book_info(hash)
def book_array(url)
  results = JSON.parse(URI.open(url).read)
  books = results["items"]
  en_books = books.filter{ |book| book["volumeInfo"]["language"] == 'en' }
  en_books.map do |en_book|
    googlebooks_id = en_book["id"] unless en_book["id"].nil?
    googlebooks_link = en_book["selfLink"] unless en_book["selfLink"].nil?
    title = en_book["volumeInfo"]["title"] unless en_book["volumeInfo"]["title"].nil?
    subtitle = en_book["volumeInfo"]["subtitle"] unless en_book["volumeInfo"]["subtitle"].nil?
    author = en_book["volumeInfo"]["authors"][0] unless en_book["volumeInfo"]["authors"].nil?
    publisher = en_book["volumeInfo"]["publisher"] unless en_book["volumeInfo"]["publisher"].nil?
    published_date = en_book["volumeInfo"]["publishedDate"] unless en_book["volumeInfo"]["publishedDate"].nil?
    description = en_book["volumeInfo"]["description"] unless en_book["volumeInfo"]["description"].nil?
    page_count = en_book["volumeInfo"]["pageCount"] unless en_book["volumeInfo"]["pageCount"].nil?
    categories = en_book["volumeInfo"]["categories"][0] unless en_book["volumeInfo"]["categories"].nil?
    language = en_book["volumeInfo"]["language"] unless en_book["volumeInfo"]["language"].nil?
    image_link = en_book["volumeInfo"]["imageLinks"]["thumbnail"] unless en_book["volumeInfo"]["imageLinks"].nil?
    {
      googlebooks_id:,
      googlebooks_link:,
      title:,
      subtitle:,
      author:,
      publisher:,
      published_date:,
      description:,
      page_count:,
      categories:,
      language:,
      image_link:
    }
  end
end

def create_seeds(book_infos, list_info)
  list = List.create!(list_info)
  book_infos.each do |book_info|
    new_book = Book.create!(book_info)
    ListBook.create!(book: new_book, list:)
  end
end

book_infos = book_array("https://www.googleapis.com/books/v1/volumes?q=inauthor:yoko+tawada&maxResults=40").select do |info|
  info[:author] == "Yoko Tawada"
end

create_seeds(
  book_infos,
  user:,
  name: "Yoko Tawada"
)

List.first.update(description: "Yoko Tawada is a renowned Japanese writer known for her unique and thought-provoking literary works. Her writing explores themes of language, identity, and cultural displacement, often blurring boundaries between genres. Tawada's evocative prose and cross-cultural perspectives have earned her international acclaim and numerous literary awards.")

book_infos = book_array("https://www.googleapis.com/books/v1/volumes?q=conspiracy+theory&maxResults=40")
create_seeds(
  book_infos,
  user:,
  name: "Conspiracy Theory"
)

List.find_by(name: "Conspiracy Theory").update(description: "Conspiracy theory is a method or belief system that suggests secretive groups or individuals are plotting or manipulating events to achieve hidden goals. It often involves attributing significant events to a covert agenda, with theories ranging from political, historical, scientific, or supernatural explanations, often lacking substantial evidence or consensus among experts.")

book_infos = book_array("https://www.googleapis.com/books/v1/volumes?q=contemporary+poetry&maxResults=40")

create_seeds(
  book_infos,
  user:,
  name: "Contemporary Poetry"
)

List.find_by(name: "Contemporary Poetry").update(description: "Contemporary poetry is characterized by its diverse forms, experimental approaches, and exploration of personal and societal themes. It often embraces ambiguity, fragmentation, and hybridity, challenging traditional structures and language. Themes include identity, social justice, and introspection, reflecting the complexities of the modern world with a distinct individualistic voice.")
