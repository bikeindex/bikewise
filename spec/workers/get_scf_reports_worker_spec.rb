require 'spec_helper'

describe GetScfReportsWorker do

  it "should get an issue page and process it" do 
    VCR.use_cassette('get_scf_report_worker') do
      Sidekiq::Testing.inline!
      expect(ScfReport.count).to eq(0)
      GetScfReportsWorker.perform_async(2)
      expect(ScfReport.count).to eq(100)
    end
  end

end
