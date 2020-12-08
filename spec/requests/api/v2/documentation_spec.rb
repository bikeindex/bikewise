require "rails_helper"

describe 'Swagger Doc', type: :request do
  it "swagger documentation" do
    get "/api/v2/swagger_doc.json"
    expect(response.code).to eq '200'
    expect(json_result["apiVersion"]).to eq "v2"
    expect(json_result["apis"].size).to be > 0
  end
end