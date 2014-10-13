require 'spec_helper'

describe Api::V1::LocationsController do
  
  describe :index do
    it "should load the page and have the correct headers" do
      get :index, format: :json
      response.code.should eq('200')
    end
  end

end