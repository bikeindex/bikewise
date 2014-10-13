class GetScfReportsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'importer'
  sidekiq_options backtrace: true
    
  def perform(page)
    integration = SeeClickFixIntegration.new
    integration.get_issues_and_make_reports(page)
  end

end