class WelcomeController < ApplicationController
  def index
    @bodyclass = 'home'
  end

  def developer
    @bodyclass = 'dev'
    @show_dev = true
  end
end