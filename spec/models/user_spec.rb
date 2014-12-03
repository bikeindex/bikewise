require 'spec_helper'

describe User do
  describe :validations do
    it { should serialize :binx_bike_ids }
    it { should serialize :legacy_bw_hash }
    it { should have_many :incidents }
    it { should belong_to :experience_level_select }
    it { should belong_to :gender_select }
    # it { should validate_presence_of :binx_id }
    it { should validate_uniqueness_of :binx_id }
  end

  describe :find_or_new_from_legacy_hash do 
    it "creates a user from legacy_bw_hash" do
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/legacy_bw_report_hash_user.json')))
      user = User.find_or_new_from_legacy_hash(hash)
      expect(user.reload.legacy_bw_hash.kind_of?(Hash)).to be_true
      expect(user.legacy_bw_id).to eq(99)
      expect(user.email).to eq(hash['verified_email'])
      expect(user.name).to eq(hash['person_name'])
      expect(user.birth_year).to eq(1961)
      expect(user.created_at.year).to eq(2009)
      expect(user.gender_select.name).to eq('male')
    end
  end
  
end
