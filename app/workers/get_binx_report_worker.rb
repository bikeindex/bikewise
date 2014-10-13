class GetBinxReportWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'importer'
  sidekiq_options backtrace: true
    
  def perform(id)
    integration = BikeIndexIntegration.new
    integration.create_or_update_binx_report(id)
  end

end