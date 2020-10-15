require 'spec_helper'

describe ProcessReportsWorker do

  it "should process a scf_report" do 
    Sidekiq::Testing.inline!
    hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/see_click_fix_issue_bike_related.json')))
    scf_report = ScfReport.find_or_new_from_external_api(hash)
    scf_report.save
    expect(scf_report.processed).to be_false
    ProcessReportsWorker.perform_async('ScfReport', scf_report.id)
    scf_report.reload
    expect(scf_report.processed).to be_true
    expect(scf_report.incident.latitude).to be_present
    expect(scf_report.incident.longitude).to be_present
    expect(scf_report.incident.image_url).to be_present
  end

  it "should process a binx_report" do 
    FactoryBot.create(:incident_type_theft)
    Sidekiq::Testing.inline!
    hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
    binx_report = BinxReport.find_or_new_from_external_api(hash)
    binx_report.save
    expect(binx_report.processed).to be_false
    ProcessReportsWorker.perform_async('BinxReport', binx_report.id)
    binx_report.reload
    expect(binx_report.processed).to be_true
    expect(binx_report.incident.latitude).to be_present
    expect(binx_report.incident.longitude).to be_present
    expect(binx_report.incident.image_url).to be_present
  end
end
