require 'spec_helper'

describe Crash do
  describe :validations do
    it { should belong_to :condition_select }
    it { should belong_to :location_select }
    it { should belong_to :crash_select }
    it { should belong_to :vehicle_select }

    # Incident_typeable attributes
    it { should have_one :incident_type }
  end

end
