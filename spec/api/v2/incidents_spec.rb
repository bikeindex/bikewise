require 'spec_helper'

describe 'Incidents API V2' do
  before :each do 
    @incident = Incident.create
  end
  
  xit "responds on index" do
    Incident.create
    get '/api/v2/incidents?per_page=1'
    result = JSON.parse(response.body)
    expect(response.header['Total']).to eq('2')
    pagination_link = "<http://www.example.com/api/v2/incidents?page=2&per_page=1>; rel=\"last\", <http://www.example.com/api/v2/incidents?page=2&per_page=1>; rel=\"next\""
    expect(response.header['Link']).to eq(pagination_link)
    response.code.should == '200'
    expect(result['incidents'][0]['id']).to eq(@incident.id)
  end

  xit "returns one with one" do
    get "/api/v2/incidents/#{@incident.id}"
    result = JSON.parse(response.body)
    response.code.should == '200'
    expect(result['incident']['id']).to eq(@incident.id)
  end

  xit "responds with missing" do 
    get "/api/v2/incidents/10000"
    response.code.should == '404'
    result = JSON.parse(response.body)
    pp result
    expect(result["message"].present?).to be_true
  end

end