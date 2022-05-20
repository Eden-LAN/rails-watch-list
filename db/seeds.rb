require 'open-uri'
require 'net/http'
require 'json'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Movie.destroy_all

top_movies_url = 'https://tmdb.lewagon.com/movie/top_rated'

class GetMovies
  def initialize(url)
    @url = url
  end

  def get_movies
    url = URI.parse(@url)
    resp = Net::HTTP.get_response(url)
    JSON.parse(resp.body)
  end
end

movie_getter = GetMovies.new(top_movies_url)

movies = movie_getter.get_movies["results"]

movies.each do |movie|
  new_movie = Movie.new(
    title: movie["original_title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w600_and_h900_bestv2#{movie['poster_path']}",
    rating: movie["vote_average"]
  )

  new_movie.save
end
