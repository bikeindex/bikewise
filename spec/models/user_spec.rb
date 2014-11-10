require 'spec_helper'

describe User do
  describe :validations do
    it { should serialize :additional_emails }
    it { should serialize :binx_bike_ids }
    it { should have_many :incidents }
    it { should validate_presence_of :binx_id }
    it { should validate_uniqueness_of :binx_id }
  end
  
end
