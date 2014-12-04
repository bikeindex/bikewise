require 'spec_helper'

describe 'Incidents API V1' do
  before :all do 
    @incident = Incident.create
  end
  
  it "responds on index" do
    Incident.create
    get '/api/v1/incidents?per_page=1'
    expect(response.header['Total']).to eq('2')
    pagination_link = "<http://www.example.com/api/v1/incidents?page=2&per_page=1>; rel=\"last\", <http://www.example.com/api/v1/incidents?page=2&per_page=1>; rel=\"next\""
    expect(response.header['Link']).to eq(pagination_link)
    response.code.should == '200'
    expect(JSON.parse(response.body)['incidents'][0]['id']).to eq(@incident.id)
  end

  it "returns one with one" do
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