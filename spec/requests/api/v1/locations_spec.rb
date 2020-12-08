require "rails_helper"

describe 'Locations API V1', type: :request do
  
  it "renders with one" do
    incident = Incident.create(latitude: 32.7348953, longitude: -117.0970596)
    # target = '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"id":' + incident.id.to_s + ',"type":"Unconfirmed"},"geometry":{"type":"Point","coordinates":[-117.0970596,32.7348953]}}]}'
    get '/api/v1/locations'
    expect(response.code).to eq '200'
    result = JSON.parse(response.body)
    expect(result['type']).to eq('FeatureCollection')
    expect(result['features'][0].keys).to eq(["type", "properties", "geometry"])
  end
end