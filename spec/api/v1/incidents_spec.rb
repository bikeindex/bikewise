require 'spec_helper'

describe 'Incidents API V1' do
  before :all do 
    @incident = Incident.create
  end
  
  it "succeeds with one" do
    pagination = '{"page":1,"per_page":10,"next_page":null,"prev_page":null,"pages":1,"total_count":1}'
    get '/api/v1/incidents'
    response.code.should == '200'
    expect(response.body).to include_json(pagination)
    expect(JSON.parse(response.body)['incidents'][0]['id']).to eq(@incident.id)
  end

  it "succeeds with one" do
    get "/api/v1/incidents/#{@incident.id}"
    response.code.should == '200'
    expect(JSON.parse(response.body)['incident']['id']).to eq(@incident.id)
  end

  it "responds with missing" do 
    get "/api/v1/incidents/10000"
    response.code.should == '404'
    expect(JSON(response.body)["message"].present?).to be_true
  end

end