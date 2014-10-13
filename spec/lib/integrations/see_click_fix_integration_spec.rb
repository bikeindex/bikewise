require 'spec_helper'

describe SeeClickFixIntegration do
  describe :get_issues_page do 
    it "should get a page of issues" do
      VCR.use_cassette('see_click_fix_get_page') do
        integration = SeeClickFixIntegration.new
        issues = integration.get_issues_page(1)
        expect(issues.kind_of?(Hash)).to be_true
        expect(issues['issues'].count).to eq(100)
      end
    end
    it "should return nil if the page is after the pagination max" do
      VCR.use_cassette('see_click_fix_get_page_after_pagination') do
        integration = SeeClickFixIntegration.new
        issues = integration.get_issues_page(100000)
        expect(issues).to be_nil
      end
    end
  end

  describe :make_reports_from_issues_page do 
    it "should create scf_reports for each issue" do 
      hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issues_page.json')))
      integration = SeeClickFixIntegration.new
      expect(ScfReport.count).to eq(0)
      integration.make_reports_from_issues_page(hash)
      expect(ScfReport.count).to eq(99)
      ScfReport.all.each { |r| expect(r.processed).to be_false }
    end
  end

  describe :get_issues_and_make_reports do
    it "should get page, process page, and return max pages" do
      VCR.use_cassette('see_click_fix_get_process_and_return_max') do
        integration = SeeClickFixIntegration.new
        integration.should_receive(:make_reports_from_issues_page).and_return(true)
        max_page = integration.get_issues_and_make_reports(1)
        expect(max_page).to be > 2000
        expect(max_page).to be < 10000
      end
    end
  end
  
end

