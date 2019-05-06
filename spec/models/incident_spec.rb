require "spec_helper"

describe Incident do
  describe :validations do
    it { should belong_to :incident_type }
    it { should belong_to :type_properties }
    it { should belong_to :country }
    it { should belong_to :user }
    it { should belong_to :gender_select }
    it { should belong_to :experience_level_select }
    it { should have_many :incident_reports }
    it { should have_many :binx_reports }
    it { should have_many :scf_reports }
    it { should have_many :images }
    it { should serialize :source }
    it { should serialize :additional_sources }
  end

  describe :as_geojson do
    it "makes it work" do
      in_type = FactoryGirl.create(:incident_type_theft)
      t = Time.now
      i1 = Incident.create(latitude: -33.891827, longitude: 151.199568, incident_type_id: in_type.id, occurred_at: t)
      i2 = Incident.create(latitude: -1.891827, longitude: 151.199568, incident_type_id: in_type.id, occurred_at: Time.now - 1.hour)
      i3 = Incident.create(latitude: -69.891827, longitude: 151.199568, incident_type_id: in_type.id, occurred_at: Time.now - 1.day)
      Incident.all.reload
      result = Incident.as_geojson
      expect(result.first[:type]).to eq("Feature")
      expect(result.first[:properties][:type]).to eq(i1.type_name)
      expect(result.first[:properties][:id]).to eq(i1.id)
      expect(result.first[:geometry][:coordinates][1]).to eq(i1.latitude)
      expect(result.first[:geometry][:coordinates][0]).to eq(i1.longitude)
      expect(result.first[:properties][:occurred_at]).to eq(t.to_i)
    end
  end

  describe :store_type_name_and_sources do
    it "sets the type name and source" do
      hash = JSON.parse(File.read(File.join(Rails.root, "/spec/fixtures/see_click_fix_issue_bike_related.json")))
      scf_report = ScfReport.find_or_new_from_external_api(hash)
      incident = Incident.create
      incident.incident_reports.create(report: scf_report, is_incident_source: true)
      expect(incident.reload.incident_reports.first.report).to eq(scf_report)
      incident.store_type_name_and_sources
      expect(incident.source).to eq(scf_report.source_hash)
      expect(incident.source_type).to eq("ScfReport")
      expect(incident.additional_sources).to eq([])
    end
    it "has a before_save_callback_method defined for store_type_name_and_sources" do
      Incident._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:store_type_name_and_sources).should == true
    end
  end

  describe :simplestyled_title do
    it "does a good title" do
      incident = Incident.new
      incident.stub(:title).and_return("Stolen 2014 GT Bicycles transeo 4.0(black and orange)")
      incident.stub(:occurred_at).and_return(Time.parse("2014-05-20 01:00:00 -0500"))
      expect(incident.simplestyled_title).to eq("Stolen 2014 GT Bicycles transeo 4.0 (05-19-2014)")
    end
  end

  describe :simplestyled_color do
    it "does color" do
      incident = Incident.new(occurred_at: Time.now - 5.hours)
      expect(incident.simplestyled_color).to eq("#BD1622")
    end
  end

  describe :simplestyled_geojson do
    it "outputs simplestyled geojson" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root, "/spec/fixtures/stolen_binx_api_response.json")))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      binx_report.save
      incident = binx_report.create_or_update_incident
      expect(incident.simplestyled_geojson[:properties][:'marker-color']).to eq("#F29D94")
    end
  end

  describe :search do
    it "searches successfully" do
      incident_type = FactoryGirl.create(:incident_type_theft)
      hash = JSON.parse(File.read(File.join(Rails.root, "/spec/fixtures/stolen_binx_api_response.json")))
      binx_report = BinxReport.find_or_new_from_external_api(hash)
      binx_report.process_hash
      binx_report.save
      incident = binx_report.create_or_update_incident
      SaverWorker.new.perform(incident.id)
      Incident.search_text("jamis").unscoped.pluck(:feature_marker)
    end
  end
end
