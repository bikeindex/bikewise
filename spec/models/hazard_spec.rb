require 'spec_helper'

describe Hazard do
  describe :validations do
    it { should belong_to :hazard_select }
    # Incident_typeable attributes
    it { should have_one :incident }
    it { should have_one :incident_type }
  end
end
