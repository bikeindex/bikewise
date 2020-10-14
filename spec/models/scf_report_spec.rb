require 'spec_helper'

describe ScfReport do
  describe :new_from_external_hash do 
    it "should make a new non bike_related scf_report from an api hash without saving" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_not_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.external_api_updated_at).to be_present
      expect(scf_report.external_api_id).to be_present
      expect(scf_report.external_api_updated_at).to be_present
      expect(scf_report.should_create_incident).to be_false
      expect(scf_report.id).to_not be_present
    end

    it "should make a new bike_related scf_report from an api hash without saving" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.external_api_updated_at).to be_present
      expect(scf_report.external_api_id).to be_present
      expect(scf_report.external_api_updated_at).to be_present
      expect(scf_report.should_create_incident).to be_true
      expect(scf_report.source_hash[:name]).to eq('SeeClickFix.com')
      expect(scf_report.source_hash[:html_url]).to eq("https://seeclickfix.com/issues/1316783")
      expect(scf_report.source_hash[:api_url]).to eq("https://seeclickfix.com/api/v2/issues/1316783")
    end

    it "should find and update a scf_report from an api hash without saving" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      og_scf_report = ScfReport.create(external_api_id: 1316783)
      expect(ScfReport.count).to eq(1)
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.external_api_id).to eq(1316783)
      expect(scf_report.should_create_incident).to be_true
      expect(scf_report.id).to eq(og_scf_report.id)
      expect(scf_report.external_api_updated_at).to be_present
      expect(ScfReport.count).to eq(1)
    end

    it "should have all the things in the attr_hash that reference parts of the bike index hash" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      hash = scf_report.incident_attrs
      expected_keys = [:latitude, :longitude, :address, :title, :description, :occurred_at, :incident_type_id, :image_url, :image_url]
      expect(expected_keys - hash.keys).to eq([])
      expect(hash[:latitude]).to eq(41.3157120640421)
      expect(hash[:longitude]).to eq(-72.9201111932928)
      expect(hash[:image_url]).to be_present
      expect(hash[:image_url_thumb]).to be_present
      expect(hash[:address]).to be_present
      expect(hash[:occurred_at].month).to eq(10)
      expect(hash[:title]).to be_present
      expect(hash[:description]).to be_present
    end

    it "should return nil if the external_api hasn't been updated since processed" do 
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      expect(scf_report.processed).to be_false
      scf_report.process_hash
      scf_report.save
      expect(scf_report.processed).to be_true
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      expect(scf_report).to_not be_present
    end
  end

  describe :incident_type_id do 
    it "should mark theft" do 
      it_type = IncidentType.create(name: 'Theft')
      summary = "abandoned bicycles"
      scf_report = ScfReport.new(external_api_hash: { summary: summary })
      expect(scf_report.incident_type_id).to eq(it_type.id)
      # scf_report[:external_api_hash][:summary] = "Sign/map needs to be replaced"
      # expect(scf_report.incident_type_id).to eq(infra.id)
    end
    it "should mark pothole as hazard" do 
      it_type = IncidentType.create(name: 'Hazard')
      summary = "Street Issue (other than pothole)"
      scf_report = ScfReport.new(external_api_hash: { summary: summary })
      expect(scf_report.incident_type_id).to eq(it_type.id)
    end
    it "should mark dangerous descriptions as hazard" do
      it_type = IncidentType.create(name: 'Hazard')
      summary = "Abandoned"
      description = "blocking part of the BIKE lane"
      scf_report = ScfReport.new(external_api_hash: { summary: summary, description: description })
      expect(scf_report.incident_type_id).to eq(it_type.id)
      scf_report[:external_api_hash][:description] = "safety HAZArd"
      expect(scf_report.incident_type_id).to eq(it_type.id)
      scf_report[:external_api_hash][:description] = ""
      scf_report[:external_api_hash][:summary] = "someone COULD get hurt"
      expect(scf_report.incident_type_id).to eq(it_type.id)
      scf_report[:external_api_hash][:summary] = "blocking foot and bike TraFFIC"
      expect(scf_report.incident_type_id).to eq(it_type.id)
    end
    it "should mark facilities & infrastructure" do 
      it_type = IncidentType.create(name: 'Infrastructure issue')
      summary = "better bicycle facilities needed on 55th St under Hwy 24"
      scf_report = ScfReport.new(external_api_hash: { summary: summary })
      expect(scf_report.incident_type_id).to eq(it_type.id)
      scf_report[:external_api_hash][:summary] = "Sign/map needs to be replaced"
      expect(scf_report.incident_type_id).to eq(it_type.id)
    end
  end

  describe :check_if_bike_related do
    it "should be true if there is cycle in the title" do 
      scf_report = ScfReport.new 
      hash = { status: 'something about a BIKE and things', description: ''}
      scf_report.stub(:external_api_hash).and_return(hash)
      expect(scf_report.check_if_bike_related).to be_true
    end
    it "should be true if there is cycle in the description" do 
      scf_report = ScfReport.new
      hash = { status: '', description: 'something about a BIcyCLE and things'}
      scf_report.stub(:external_api_hash).and_return(hash)
      expect(scf_report.check_if_bike_related).to be_true
    end
  end

  describe :create_or_update_incident do 
    it "should not create an incident if report is not bike related" do 
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_not_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.processed).to be_true
      expect(scf_report.incident).to_not be_present
      scf_report.create_or_update_incident
      expect(scf_report.incident).to_not be_present
    end

    it "should create an incident if report is bike related" do 
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.incident).to_not be_present
      incident = scf_report.create_or_update_incident
      scf_report.reload
      expect(scf_report.incident_report).to be_present
      expect(scf_report.incident).to be_present
      expect(scf_report.incident.id).to eq(incident.id)
      expect(scf_report.incident_report.is_incident_source).to be_true

      hash = scf_report.incident_attrs
      expect(incident.latitude).to eq(hash[:latitude])
      expect(incident.longitude).to eq(hash[:longitude])
      expect(incident.occurred_at).to eq(hash[:occurred_at])
      expect(incident.create_open311_report).to be_false
      expect(incident.title).to be_present
      expect(incident.type_name).to eq('Unconfirmed')
      expect(incident.description).to be_present
      expect(incident.source).to eq(scf_report.source_hash)
      expect(incident.source_type).to eq('ScfReport')
    end

    xit "should not change the source or the incident_type if incident already exists" do 
      incident_type = IncidentType.create(name: 'Some type')
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
      incident = Incident.create(source: 'Some other source', incident_type: incident_type)
      ScfReport.create(external_api_id: 1316783, incident_id: incident.id)
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      scf_report.process_hash
      expect(scf_report.incident).to be_present
      expect(Incident.count).to eq(1)
      incident = scf_report.create_or_update_incident
      expect(Incident.count).to eq(1)
      expect(incident.scf_report.id).to eq(scf_report.id)
      expect(incident.source).to eq('Some other source')
      expect(incident.incident_type_id).to eq(incident_type.id)
    end
  end

end
