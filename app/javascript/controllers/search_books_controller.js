import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-movies"
export default class extends Controller {
  static targets = ["input", "searchResult"]
  connect() {
    console.log(this.inputTarget.value);
    console.log(this.searchResultTarget);
  }

  update() {
    console.log((this.inputTarget.value).replace(/\s+/g, "+"))
    const url = `https://www.googleapis.com/books/v1/volumes?q=${(this.inputTarget.value).replace(/\s+/g, "+")}&maxResults=40&langRestrict=en`
    fetch(url)
    .then(response => response.json())
    .then(data => this.insertBooks(data))
  }

  insertBooks(data) {
    const searchResults = this.searchResultTarget
    const bookInfos = data.items // an array of hashes
    searchResults.innerHTML = ""
    bookInfos.forEach (bookInfo => {
      searchResults.insertAdjacentHTML("beforeend", `<h2>${bookInfo.volumeInfo.title}</h2>`)
      searchResults.insertAdjacentHTML("beforeend", `<p><a href="books/${bookInfo.id}">see details</a></p>`);
    })
  }
}
