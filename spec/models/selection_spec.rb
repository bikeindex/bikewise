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
  end

end
