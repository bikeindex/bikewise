require 'spec_helper'

describe BwReport do
  describe :validations do
    # it { should validate_presence_of :binx_id }

    # Incidentable attributes
    it { should have_one :incident_report }
    it { should have_one :incident }
    it { should validate_uniqueness_of(:external_api_id).allow_nil }
    it { should serialize :external_api_hash }
  end

  describe :new_from_external_hash do 
    it "should make a binx report from an api hash and not save" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/bw_report_hash.json')))
      bw_report = BwReport.find_or_new_from_external_api(hash)
      bw_report.process_hash
      expect(bw_report.external_api_updated_at).to be_present
      expect(bw_report.id).to_not be_present
      expect(bw_report.source[:name]).to eq('BikeWise.org')
    end

    it "should have the incident_attrs" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/bw_report_hash.json')))
      bw_report = BwReport.find_or_new_from_external_api(hash)
      bw_report.process_hash
      bw_report.stub(:incident_type_id).and_return(69)
      hash = bw_report.incident_attrs

      expected_keys = [:latitude, :longitude, :address, :title, :description, :occurred_at, :incident_type_id, :image_url, :image_url, :create_open311_report]
      expect(expected_keys - hash.keys).to eq([])
      expect(hash[:latitude]).to eq(41.92031)
      expect(hash[:longitude]).to eq(-87.715781)
      expect(hash[:image_url]).to be_present
      expect(hash[:image_url_thumb]).to be_present
      expect(hash[:post_to_scf]).to be_false
      expect(hash[:description]).to match("This is a report.")
    end

    it "should return always be processed, because there isn't a reason for us to call it unless it's updated" do 
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/bw_report_hash.json')))
      bw_report = BwReport.find_or_new_from_external_api(hash)
      expect(bw_report.processed).to be_false
      bw_report.process_hash
      bw_report.save
      expect(bw_report.processed).to be_true
      bw_report = BwReport.find_or_new_from_external_api(hash)
      expect(bw_report).to be_present
    end
  end

  describe :create_or_update_incident do
    it "should create an incident" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/bw_report_hash.json')))
      bw_report = BwReport.find_or_new_from_external_api(hash)
      bw_report.process_hash
      expect(bw_report.incident).to_not be_present
      incident = bw_report.create_or_update_incident
      bw_report.reload
      expect(bw_report.incident_report).to be_present
      expect(bw_report.incident).to be_present
      expect(bw_report.incident.id).to eq(incident.id)
      expect(bw_report.incident_report.is_incident_source).to be_true

      hash = bw_report.incident_attrs
      expect(incident.latitude).to eq(hash[:latitude])
      expect(incident.longitude).to eq(hash[:longitude])
      expect(incident.occurred_at).to eq(hash[:occurred_at])
      expect(incident.create_open311_report).to be_false
      expect(incident.title).to be_present
      expect(incident.description).to be_present
      expect(incident.description).to be_present
      expect(incident.description).to be_present
      expect(incident.incident_type_id).to eq(incident_type.id)
      expect(incident.id).to be_present
      expect(incident.source[:name]).to match('BikeWise')
    end

  end

end
