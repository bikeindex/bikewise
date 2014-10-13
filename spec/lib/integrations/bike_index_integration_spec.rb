require 'spec_helper'

describe BikeIndexIntegration do
  describe :create_or_update_binx_report do 
    it "should create a bike" do 
      VCR.use_cassette('bike_index_create_bike') do
        integration = BikeIndexIntegration.new 
        expect(BinxReport.count).to eq(0)
        integration.create_or_update_binx_report(3414)
        expect(BinxReport.count).to eq(1)
        binx_report = BinxReport.last
        expect(binx_report.processed).to be_false
        binx_report.process_hash
        expect(binx_report.external_api_hash[:title]).to match("2014 Jamis Allegro Comp Disc")
        expect(binx_report.binx_id).to eq(3414)
        expect(binx_report.external_api_id).to eq(146)
        expect(binx_report.external_api_updated_at).to be_present
        expect(binx_report.external_api_checked_at).to be_present
      end
    end

    it "should not create a bike if the bike doesn't exist" do 
      VCR.use_cassette('bike_index_create_missing_bike') do
        integration = BikeIndexIntegration.new 
        expect(BinxReport.count).to eq(0)
        integration.create_or_update_binx_report(1)
        expect(BinxReport.count).to eq(0)
      end
    end
    
    it "shouldn't create a duplicate bike" do 
      time = Time.now - 1.day
      binx_report = BinxReport.create(binx_id: 3414,
        external_api_id: 146,
        external_api_updated_at: time,
        external_api_checked_at: time)
      expect(binx_report.external_api_checked_at).to eq(time)
      expect(binx_report.external_api_updated_at).to eq(time)
      integration = BikeIndexIntegration.new
      bike_hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
      BikeIndexIntegration.any_instance.should_receive(:get_request).and_return(bike_hash)
      integration = BikeIndexIntegration.new 
      expect(BinxReport.count).to eq(1)
      integration.create_or_update_binx_report(3414)
      expect(BinxReport.count).to eq(1)
      binx_report.reload
      binx_report.process_hash
      expect(binx_report.external_api_hash[:title]).to match("2014 Jamis Allegro Comp Disc")
      expect(binx_report.binx_id).to eq(3414)
      expect(binx_report.external_api_checked_at).not_to eq(time)
      expect(binx_report.external_api_updated_at).not_to eq(time)
    end
  end

  describe :get_stolen_bikes_updated_since do 
    it "should get the stolen bikes updated since" do 
      # Because the auth stuff is in the ENV file, which peeps might not have
      # Only run test if the auth token exists
      if ENV['BIKEINDEX_ACCESS_TOKEN'].present?
        VCR.use_cassette('bike_index_get_stolen_bikes_updated_since') do
          party_time = Time.parse('2014-10-10 14:44:11 -0500')
          integration = BikeIndexIntegration.new 
          stolen_ids = integration.get_stolen_bikes_updated_since(party_time)
          expect(stolen_ids.kind_of?(Array)).to be_true
          expect(stolen_ids.count).to be > 30
        end
      end
    end
  end
end
