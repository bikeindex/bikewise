require 'spec_helper'

describe SaverWorker do

  it "saves the simplestyled geojson when run and enqueues when created" do 
    require 'sidekiq/testing'
    Sidekiq::Testing.fake!
    incident_type = FactoryGirl.create(:incident_type_theft)
    hash = JSON.parse(File.read(File.join(Rails.root,'/spec/fixtures/stolen_binx_api_response.json')))
    binx_report = BinxReport.find_or_new_from_external_api(hash)
    binx_report.process_hash
    binx_report.save
    expect {
      binx_report.create_or_update_incident
    }.to change(SaverWorker.jobs, :size).by(1)
    SaverWorker.drain
    binx_report.reload
    expect(binx_report.incident.feature_marker['properties']['marker-color']).to eq("#E74C3C")
  end

end
