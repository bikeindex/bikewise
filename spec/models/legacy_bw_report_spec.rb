require 'spec_helper'

describe LegacyBwReport do
  describe :new_from_external_hash do 
    it "should make a binx report from an api hash and not save" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/legacy_bw_report_hash_crash.json')))
      bw_report = LegacyBwReport.find_or_new_from_external_api(hash)
      bw_report.process_hash
      expect(bw_report.external_api_updated_at).to be_present
      expect(bw_report.id).to_not be_present
      expect(bw_report.legacy_bw_user_id).to be_present
      expect(bw_report.source_hash[:name]).to eq('Bikewise.org')
    end

    it "should have the incident_attrs" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/legacy_bw_report_hash_crash.json')))
      bw_report = LegacyBwReport.find_or_new_from_external_api(hash)
      bw_report.process_hash
      bw_report.stub(:incident_type_id).and_return(69)
      hash = bw_report.incident_attrs
      expected_keys = [:latitude, :longitude, :address, :title, :description, :occurred_at, :incident_type_id]
      expect(expected_keys - hash.keys).to eq([])
      expect(hash[:latitude].length).to be > 5
      expect(hash[:longitude].length).to be > 5
      expect(hash[:description].length).to be > 100
    end

  end

  describe :create_crash do 
    before :each do 
      @hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/legacy_bw_report_hash_crash.json')))
      @bw_report = LegacyBwReport.find_or_new_from_external_api(@hash)
      @bw_report.save
      @bw_report.reload.create_or_update_incident
      @bw_report.reload
      @incident = @bw_report.incident
    end

    it "creates crash with the selects" do
      expect(@incident.type_properties_type).to eq('Crash')
      crash = @incident.type_properties
      ['condition', 'crash', 'vehicle', 'lighting', 'visibility', 'injury_severity', 'geometry'].each do |type|
        expect(crash.send("#{type}_select")).to be_present
      end
      expect(crash.geometry_select.name).to eq(@bw_report.geometry_from_hash.downcase)
    end

    it "sets the correct incident attrs" do 
      expect(@incident.experience_level_select.name).to eq(@hash['cyclist_experience'])
      expect(@incident.gender_select.name).to eq('male')
      expect(@incident.location_select.name).to eq(@hash['location_type'])
      expect(@incident.location_description).to eq(@hash['location_desc'])
      expect(@incident.age).to eq(@hash['cyclist_age'].to_i)
      expect(@incident.description.length).to be > 50
      expect(@incident.latitude.present?).to be_true
      expect(@incident.longitude.present?).to be_true
      expect(@incident.address.present?).to be_true
      expect(@incident.title.present?).to be_true
      expect(@incident.incident_type_id).to be > 0
    end
  end

  describe :create_hazard do 
    before :each do 
      @hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/legacy_bw_report_hash_hazard.json')))
      @bw_report = LegacyBwReport.find_or_new_from_external_api(@hash)
      @bw_report.save
      @bw_report.reload.create_or_update_incident
      @bw_report.reload
      @incident = @bw_report.incident
    end

    it "creates hazard with the selects" do
      expect(@incident.type_properties_type).to eq('Hazard')
      hazard = @incident.type_properties
      expect(hazard.hazard_select.name).to eq(@hash['hazard_type'])
      expect(hazard.priority_select.name).to eq(@hash['priority'])
    end

    it "sets the correct incident attrs" do 
      expect(@incident.location_select.name).to eq(@hash['location_type'])
      expect(@incident.location_description).to eq(@hash['location_desc'])
      expect(@incident.description.length).to be > 50
      expect(@incident.latitude.present?).to be_true
      expect(@incident.longitude.present?).to be_true
      expect(@incident.address.present?).to be_true
      expect(@incident.title.present?).to be_true
      expect(@incident.incident_type_id).to be > 0
    end
  end

end
