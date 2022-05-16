require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end
  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    count = 1
    random_letters = []
    while count <= grid_size
      random_letters << ("A".."Z").to_a.sample
      count += 1
    end
    random_letters
  end
  def exist
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end

  def in_grid(grid)
    a1 = params[:word].split("")
    #
    final = true
    a1.each do |x|
      if grid.include?(x)
        final = final && true
        grid.slice!(grid.index(x))
      else
        final = final && false
      end
    end
    final
  end

  def new
    @letters = generate_grid(10)
  end

  def score
    @result_exist = exist
    @letters = params[:letters]
    @letters_good = @letters.dup
    @result_in_grid = in_grid(@letters)
    if !@result_in_grid
      @final_result = "Sorry but #{params[:word]} cant be build out of #{@letters_good}"
    elsif @result_in_grid && !@result_exist
      @final_result = "Sorry but #{params[:word]} does not seem to be a valid word"
    else
      @final_result = "Congratulations! #{params[:word]} is a valid english word!"
    end
  end
end
