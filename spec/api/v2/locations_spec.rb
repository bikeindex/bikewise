require "spec_helper"

describe "Locations API V2" do
  describe "root" do
    it "renders with one" do
      incident = Incident.create(latitude: 32.7348953, longitude: -117.0970596)
      # target = '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"id":' + incident.id.to_s + ',"type":"Unconfirmed"},"geometry":{"type":"Point","coordinates":[-117.0970596,32.7348953]}}]}'
      get "/api/v2/locations"
      response.code.should == "200"
      result = JSON.parse(response.body)
      expect(result["type"]).to eq("FeatureCollection")
      expect(result["features"][0].keys).to eq(["type", "properties", "geometry"])
    end

    it "does occurred after" do
      old_incident = Incident.create(latitude: 32.7348953, longitude: -117.0970596, occurred_at: Time.now - 1.week)
      incident = Incident.create(latitude: 32.7348953, longitude: -117.0970596, occurred_at: Time.now)
      # target = '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"id":' + incident.id.to_s + ',"type":"Unconfirmed"},"geometry":{"type":"Point","coordinates":[-117.0970596,32.7348953]}}]}'
      get "/api/v2/locations?occurred_after=#{(Time.now - 1.day).to_i}"
      response.code.should == "200"
      result = JSON.parse(response.body)
      expect(result["type"]).to eq("FeatureCollection")
      expect(result["features"].count).to eq(1)
      expect(result["features"][0].keys).to eq(["type", "properties", "geometry"])
    end
  end

  describe "markers" do
    it "renders with one" do
      hash = JSON.parse(File.read(File.join(Rails.root, "/spec/fixtures/stolen_binx_api_response.json")))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      binx_report.save
      incident = binx_report.create_or_update_incident
      SaverWorker.new.perform(incident.id)
      hash2 = JSON.parse(File.read(File.join(Rails.root, "/spec/fixtures/stolen_binx_api_response_2.json")))
      binx_report2 = BinxReport.find_or_new_from_external_api(hash2)
      binx_report2.process_hash
      binx_report2.save
      incident2 = binx_report2.create_or_update_incident
      SaverWorker.new.perform(incident2.id)
      get "/api/v2/locations/markers?query=christmas"
      result = JSON.parse(response.body)
      expect(result["type"]).to eq("FeatureCollection")
      expect(result["features"].count).to eq(1)
      expect(result["features"][0]["properties"]["marker-color"]).to eq("#F6B9B3")
      response.code.should == "200"
    end
  end
end
