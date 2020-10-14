require 'spec_helper'

describe DocumentationController, type: :controller do

  describe :index do 
    it "renders" do
      get :index
      expect(response).to redirect_to("/documentation/api_v2")
    end
  end

  describe :api_v1 do 
    it "redirects" do
      get :api_v1
      expect(response).to redirect_to("/documentation/api_v2")
    end
  end

  describe :api_v2 do 
    it "renders" do
      get :api_v2
      expect(response.code).to eq "200"
      expect(response).to render_template("api_v2")
    end
  end
end
