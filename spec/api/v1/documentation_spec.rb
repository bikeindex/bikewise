require "spec_helper"

describe "Swagger Doc" do
  it "swagger documentation" do
    get "/api/swagger_doc.json"
    response.code.should == "200"
    json_response = JSON.parse(response.body)
    json_response["apiVersion"].should == "v1"
    pp json_response
    json_response["apis"].size.should > 0
  end
end
