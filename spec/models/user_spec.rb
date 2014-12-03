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

  describe :from_omniauth do 
    it "creates a user and uses that user if called again" do 
      auth = OmniAuth.config.mock_auth[:bike_index] = OmniAuth::AuthHash.new({
        :provider => :bike_index,
        uid: '123545',
        info: {
          email: 'foo@bar.com',
          name: 'foo',
          bike_ids: [1]
        }
      })
      user = User.from_omniauth(auth)
      expect(user.id).to be_present
      expect(user.password).to be_present
      expect(user.binx_bike_ids).to eq([1])
      user_again = User.from_omniauth(auth)
      expect(user.id).to eq(user_again.id)
    end
    it "associates user with existing user" do 
      user = User.create(email: 'legacy@bw.com', legacy_bw_id: 99, password: 'foo888888')
      auth = OmniAuth.config.mock_auth[:bike_index] = OmniAuth::AuthHash.new({
        :provider => :bike_index,
        uid: '123545',
        info: {
          email: 'legacy@bw.com',
          name: 'foo',
          bike_ids: [1]
        }
      })
      user_authed = User.from_omniauth(auth)
      expect(user_authed.id).to eq(user.id)
      expect(user_authed.binx_id).to eq('123545')
    end
  end

  # <OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1417578639 refresh_token="4d608d8f918747aff2c9cd403ee6b5d9db659dd04a101c28f4983a7d28bb5e01" token="c69d1aa254d9982884beeb395c2963ec358fe7071fec5270581b27bb22ab8c9d"> extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash access_token=#<OmniAuth::AuthHash application="Bikewise" scope=["read_bikes", "read_user", "write_user", "write_bikes", "read_bikewise", "write_bikewise", "read_organization_membership"]> bike_ids=[6, 35, 65, 2, 32, 29367] id="85" memberships=[#<OmniAuth::AuthHash organization_access_token="36f69976c072df53511065725ff52f89" organization_name="Bike Index Administrators" organization_slug="bikeindex" user_is_organization_admin=true>, #<OmniAuth::AuthHash organization_access_token="f4f83681b8c7f18c7da88602a58f9c6b" organization_name="BikeWise" organization_slug="bikewise" user_is_organization_admin=true>] user=#<OmniAuth::AuthHash email="seth@bikeindex.org" image="https://bikeindex.s3.amazonaws.com/uploads/Us/85/Seth-Herr.jpg" name="Seth Herr" twitter="sethherr" username="seth">>> info=#<OmniAuth::AuthHash::InfoHash bike_ids=[6, 35, 65, 2, 32, 29367] email="seth@bikeindex.org" image="https://bikeindex.s3.amazonaws.com/uploads/Us/85/Seth-Herr.jpg" name="Seth Herr" twitter="sethherr" username="seth"> provider=:bike_index uid="85">
  
end
