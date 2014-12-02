require 'spec_helper'

describe Selection do
  describe :validations do
    it { should have_many :hazard_selects }
    it { should have_many :locking_selects }
    it { should have_many :locking_defeat_selects }
    it { should have_many :condition_selects }
    it { should have_many :location_selects }
    it { should have_many :crash_selects }
    it { should have_many :vehicle_selects }
    it { should have_many :lighting_selects }
    it { should have_many :visibility_selects }
    it { should have_many :geometry_selects }
    it { should have_many :injury_severity_selects }
    it { should have_many :incident_experience_level_selects }
    it { should have_many :incident_gender_selects }
  end

  describe :possible_types do 
    it "plucks possible types" do 
      Selection.create(name: 'foo', select_type: 'foo')
      Selection.create(name: 'bar', select_type: 'foo')
      expect(Selection.possible_types.include?('foo')).to be_true
    end
  end
end
