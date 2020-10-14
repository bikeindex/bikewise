require "spec_helper"

describe "Swagger Doc", type: :request do
  it "swagger documentation" do
    get "/api/swagger_doc.json"
    json_response = JSON.parse(response.body)
    expect(json_response.is_a?(Hash)).to eq true
    expect(response.code).to eq "200"
    # These are tests of what it once was
    # expect(json_response["apiVersion"]).to eq "v1"
    # expect(json_response["apis"].size).to be > 0
  end
end
