require 'pg'
require 'database_connection'

class Bookmark

  attr_reader :id, :url, :title
  
  def initialize(id:, url:, title:)
    @id = id
    @url = url
    @title = title
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bookmarks")
    result.map do |bookmark|
      Bookmark.new(
        url: bookmark['url'],
        title: bookmark['title'],
        id: bookmark['id']
      )
    end
  end

  def self.create(url:, title:)
    result = DatabaseConnection.query(
      "INSERT INTO bookmarks(url, title) VALUES($1, $2) RETURNING id, title, url;", [url, title]
    )
    Bookmark.new(id: result[0]['id'], url: result[0]['url'], title: result[0]['title'])
  end

  def self.delete(id:)
    result = DatabaseConnection.query("DELETE FROM bookmarks WHERE id = $1", [id])
  end

  def self.update(id:, url:, title:)
    result = DatabaseConnection.query(
      "UPDATE bookmarks SET url = $1, title = $2 WHERE id = $3 RETURNING id, url, title;",
      [url, title, id]
    )
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.find(id:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookmarks WHERE id = $1;", [id]
    )
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end
end
