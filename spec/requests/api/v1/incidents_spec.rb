require "rails_helper"

describe 'Incidents API V2', type: :request do
  before :each do 
    @incident = Incident.create
  end
  
  it "responds on index" do
    Incident.create
    get '/api/v2/incidents?per_page=1'
    expect(response.header['Total']).to eq('2')
    pagination_link = "<http://www.example.com/api/v2/incidents?page=2&per_page=1>; rel=\"last\", <http://www.example.com/api/v2/incidents?page=2&per_page=1>; rel=\"next\""
    expect(response.header['Link']).to eq(pagination_link)
    expect(response.code).to eq '200'
    expect(json_result['incidents'][0]['id']).to eq(@incident.id)
  end
end