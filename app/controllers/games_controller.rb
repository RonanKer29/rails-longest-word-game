require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]

    if !word_in_grid?(@word, @letters)
      @result = "Sorry, but #{@word} can't be built out of #{@letters}"
    elsif !english_word?(@word)
      @result = "Sorry, but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
