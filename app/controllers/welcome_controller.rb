class WelcomeController < ApplicationController
  def index
    @bodyclass = 'home'
  end

  def developer
    @bodyclass = 'dev'
  end
end