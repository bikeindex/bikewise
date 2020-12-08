require "rails_helper"

describe User do
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

  describe :migrate_legacy_bw_user do 
    before :each do 
      @user = User.create(email: 'legacy@bw.com', legacy_bw_id: 99, password: 'foo888888', name: 'Georgey', birth_year: 1999)
      @user2 = User.create(email: 'legacy+stuff@bw.com', password: 'foo888888', name: 'George')
    end
    it "is true if email isn't present" do
      expect(@user2.migrate_legacy_bw_user).to be_true
    end
    it "is true if legacy legacy_bw_id already exists" do
      @user2.legacy_bw_id = 999
      @user2.legacy_bw_email = 'legacy@bw.com'
      expect(@user2.migrate_legacy_bw_user).to be_true
    end
    it "migrates in legacy bw user if one is found" do
      @user2.legacy_bw_email = @user.email
      @user2.migrate_legacy_bw_user
      expect(User.where(id: @user.id)).to_not be_present
      expect(@user2.email).to eq('legacy+stuff@bw.com')
      expect(@user2.name).to eq('George')
      expect(@user2.birth_year).to eq(1999)
    end
  end

  
end
