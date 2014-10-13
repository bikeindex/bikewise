require 'spec_helper'

describe IncidentType do
  describe :validations do
    # it { should validate_presence_of :slug }
    # it { should validate_uniqueness_of :slug }
    # it { should have_many :incidents }
  end

  describe :fuzzy_find_id do 
    it "should fuzzy_find incident_type_id" do 
      incident_type = IncidentType.create(name: 'Some WEird Thing')
      find = IncidentType.fuzzy_find_id('some weird thing  ')
      expect(find).to eq(incident_type.id)
    end
    it "shouldn't break on failure" do 
      IncidentType.create(name: 'Crash')
      find = IncidentType.fuzzy_find_id('theweirdest thing  ')
      expect(find).to be_nil
    end
  end

  
end
