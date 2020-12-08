require "rails_helper"

describe GetBinxReportWorker do

  it "gets an issue page and process it" do 
    VCR.use_cassette('get_binx_report_worker') do
      Sidekiq::Testing.inline!
      expect(BinxReport.count).to eq(0)
      GetBinxReportWorker.perform_async(3414)
      expect(BinxReport.count).to eq(1)
    end
  end

end
