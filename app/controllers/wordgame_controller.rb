require 'open-uri'
require 'json'

class WordgameController < ApplicationController
  def game
    @start_time = Time.now
    @grid = generate_grid(9).join(' ')
  end

  def score
    @end_time = Time.now
    @attempt = params[:attempt]
    @grid = params[:grid]
    start_time = Time.parse(params[:start_time])
    @result = run_game(@attempt, @grid, start_time, @end_time)
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(strike, grid)
    strike.chars.all? { |letter| strike.count(letter) <= grid.count(letter) }
  end

  def calc_score(attempt, timer)
    (timer > 60.0) ? 0 : attempt.size * (1.0 - timer / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }
    result[:score], result[:message] = score_message(
      attempt, grid, result[:time])
    result
  end

  def score_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      score = calc_score(attempt, time)
      [score, "God Job!"]
    else
      [0, "It is not in the grid!"]
    end
  end
end
