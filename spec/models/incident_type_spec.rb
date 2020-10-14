require 'spec_helper'

describe IncidentType do
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

  describe :possible_types do 
    it "plucks possible types" do 
      IncidentType.create(name: 'foo')
      expect(IncidentType.possible_types.include?('foo')).to be_true
    end
  end
end
