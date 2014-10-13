require 'spec_helper'

describe Api::V1::IncidentsController do
  
  describe :index do
    it "should load the page and have the correct headers" do
      get :index, format: :json
      response.code.should eq('200')
    end
  end

  describe :show do
    it "should load the page and have the correct headers" do
      incident = Incident.create
      get :show, id: incident.id, format: :json
      response.code.should eq('200')
    end
  end

  describe :create do 
    it "should create an incident" do
      incident = File.read(File.join(Rails.root,'/spec/fixtures/bw_report_hash.json'))
      expect(BwReport.count).to eq(0)
      post :create, incident: incident
      expect(response.code).to eq('200')
      expect(BwReport.count).to eq(1)
      report = BwReport.last
      expect(report.external_api_hash[:latitude]).to eq(41.92031)
      expect(report.external_api_hash[:longitude]).to eq(-87.715781)
      expect(report.external_api_hash[:media][:image_url]).to be_present
    end
  end

end