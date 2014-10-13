require 'spec_helper'

describe BinxReport do
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
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      expect(binx_report.external_api_id).to be_present
      expect(binx_report.external_api_updated_at).to be_present
      expect(binx_report.binx_id).to be_present
      expect(binx_report.id).to_not be_present
      expect(binx_report.source[:name]).to eq('BikeIndex.org')
      expect(binx_report.source[:html_url]).to eq("https://bikeindex.org/bikes/3414")
      expect(binx_report.source[:api_url]).to eq("https://bikeindex.org/api/v1/bikes/3414")
    end

    it "should find and update a binx_report from an api hash and not break the second time" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      og_binx_report = BinxReport.create(external_api_id: 146, binx_id: 69)
      expect(BinxReport.count).to eq(1)
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      expect(binx_report.external_api_id).to eq(146)
      expect(binx_report.binx_id).to be_present
      expect(binx_report.id).to eq(og_binx_report.id)
      expect(BinxReport.count).to eq(1)
      # make sure we aren't messing up with the root container for bikes
      expect(binx_report.process_hash).to eq(binx_report)
    end

    it "should have the incident_attrs" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      binx_report.stub(:incident_type_id).and_return(69)
      hash = binx_report.incident_attrs

      expected_keys = [:latitude, :longitude, :address, :title, :description, :occurred_at, :incident_type_id, :image_url, :image_url, :create_open311_report]
      expect(expected_keys - hash.keys).to eq([])
      expect(hash[:latitude]).to eq(41.92031)
      expect(hash[:longitude]).to eq(-87.715781)
      expect(hash[:image_url]).to be_present
      expect(hash[:image_url_thumb]).to be_present
      expect(hash[:post_to_scf]).to be_false
      expect(hash[:title]).to match(/Stolen 2014 Jamis Allegro Comp Disc .blue./)
      expect(hash[:description]).to match("This is a test stolen bike.")
    end
  end

  describe :create_or_update_incident do
    it "should create an incident" do 
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      expect(binx_report.incident).to_not be_present
      incident = binx_report.create_or_update_incident
      binx_report.reload
      expect(binx_report.incident_report).to be_present
      expect(binx_report.incident).to be_present
      expect(binx_report.incident.id).to eq(incident.id)
      expect(binx_report.incident_report.is_incident_source).to be_true

      hash = binx_report.incident_attrs
      expect(incident.latitude).to eq(hash[:latitude])
      expect(incident.longitude).to eq(hash[:longitude])
      expect(incident.occurred_at).to eq(hash[:occurred_at])
      expect(incident.create_open311_report).to be_false
      expect(incident.title).to be_present
      expect(incident.description).to be_present
      expect(incident.description).to be_present
      expect(incident.type_name).to eq('Theft')
      expect(incident.incident_type_id).to eq(incident_type.id)
    end

    xit "should not change the source or the incident_type if incident already exists" do 
      incident_type = IncidentType.create(name: 'Some type')
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      incident = Incident.create()
      scf_report = ScfReport.create
      BinxReport.create(external_api_id: 146, binx_id: 69, incident_id: incident.id)
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash.save
      binx_report.reload
      expect(binx_report.incident).to be_present
      expect(Incident.count).to eq(1)
      incident = binx_report.create_or_update_incident
      expect(Incident.count).to eq(1)
      expect(IncidentReport.count).to eq(1)
      # expect(incident.source).to eq('Some other source')
      expect(incident.incident_type_id).to eq(incident_type.id)
    end
  end

end
