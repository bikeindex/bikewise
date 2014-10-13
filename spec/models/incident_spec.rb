require 'spec_helper'

describe Incident do
  describe :validations do
    it { should belong_to :incident_type }
    it { should have_many :incident_reports }
    it { should have_many :binx_reports }
    it { should have_many :scf_reports }
    it { should serialize :source }
  end

  describe :as_geojson do 
    it "should make it work" do 
      in_type = FactoryGirl.create(:incident_type_theft)
      i1 = Incident.create(latitude: -33.891827, longitude: 151.199568, incident_type: in_type)
      i2 = Incident.create(latitude: -1.891827, longitude: 151.199568, incident_type: in_type)
      i3 = Incident.create(latitude: -69.891827, longitude: 151.199568, incident_type: in_type)
      result = Incident.as_geojson
      expect(result.first[:type]).to eq('Feature')
      expect(result.first[:properties][:type]).to eq(i1.type_name)
      expect(result.first[:properties][:id]).to eq(i1.id)
      expect(result.first[:geometry][:coordinates][0]).to eq(i1.latitude)
      expect(result.first[:geometry][:coordinates][1]).to eq(i1.longitude)
    end
  end

end
