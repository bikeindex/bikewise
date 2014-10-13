class IncidentReport < ActiveRecord::Base
  # Thanks to https://gist.github.com/runemadsen/1242485 for example 
  #        and explanation of reverse polymorphic associations
  # 
  # Attributes  is_open311_report, is_incident_source
  # 

  belongs_to :incident 
  belongs_to :report, polymorphic: true

  before_save :set_open311_status
  def set_open311_status
    self.is_open311_report = report.is_open311_report
    true
  end
end
