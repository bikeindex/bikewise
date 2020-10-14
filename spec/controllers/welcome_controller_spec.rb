require 'spec_helper'

describe WelcomeController, type: :controller do

  describe 'index' do 
    it "renders" do
      get :index
      expect(response.code).to eq "200"
      expect(response).to render_template("index")
    end
  end

  describe 'developer' do 
    it "renders" do
      get :developer
      expect(response.code).to eq "200"
      expect(response).to render_template("developer")
    end
  end
end