require "rails_helper"

describe IncidentReport do
  describe :set_open_311_status do 
    it "should set the incident as open311 if it is and make it the source" do 
      incident = Incident.new
      scf_report = ScfReport.new
      incident_report = IncidentReport.new
      incident_report.stub(:report).and_return(scf_report)
      incident_report.stub(:incident).and_return(incident)
      incident_report.set_open311_status
      expect(incident_report.is_open311_report).to be_true
    end

    it "should have before_save_callback_method defined for set_mnfg_name" do
      expect(IncidentReport._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:set_open311_status)).to eq true
    end
  end
end
