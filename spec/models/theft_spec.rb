require 'spec_helper'

describe Theft do
  describe :validations do
    it { should belong_to :locking_defeat_select }
    it { should belong_to :locking_select }

    # Incident_typeable attributes
    it { should have_one :incident_type }
  end

end
