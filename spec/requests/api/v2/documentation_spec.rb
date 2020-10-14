require 'spec_helper'

describe 'Swagger Doc', type: :request do
  it "swagger documentation" do
    get "/api/v2/swagger_doc.json"
    json_response = JSON.parse(response.body)
    expect(json_response.is_a?(Hash)).to eq true
    expect(response.code).to eq '200'
    # These are tests of what it once was
    # expect(json_response["apiVersion"]).to == "v2"
    # expect(json_response["apis"].size).to > 0
  end
end