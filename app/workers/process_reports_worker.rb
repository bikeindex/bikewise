class ProcessReportsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'parser'
  sidekiq_options backtrace: true
  sidekiq_options unique: true
    
  def perform(klass, id)
    report = klass.constantize.find(id)
    report.reload.process_hash
    report.save
    report.reload.create_or_update_incident
    report.save
  end

end