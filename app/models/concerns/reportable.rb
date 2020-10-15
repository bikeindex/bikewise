module Reportable
  extend ActiveSupport::Concern
  # Attributes:  external_api_id, incident_id,
  #              external_api_checked_at, external_api_updated_at
  #              processed

  included do
    serialize :external_api_hash
    validates_uniqueness_of :external_api_id, allow_nil: true
    has_one :incident_report, as: :report
    has_one :incident, through: :incident_report
    scope :unprocessed, -> { where(should_create_incident: true).where(processed: false) }
    scope :processed, -> { where(should_create_incident: true).where(processed: true) }
  end

  def process_hash
    set_attrs_from_hash
    do_not_process_without_address
    self.processed = true
    self
  end

  def create_or_update_incident
    return nil unless should_create_incident
    u_incident = incident
    unless u_incident.present?
      u_incident = Incident.create
      ir = u_incident.incident_reports.create(report: self, is_incident_source: true)
      unless incident_report.present?
        raise StandardError, "IncidentReport create error #{self.class.name} #{id} - #{ir.errors.full_messages.to_sentence}"
      end
    end
    u_incident.attributes = incident_attrs
    u_incident.incident_type_id = incident_type_id
    u_incident.save
    after_incident_actions if self.methods.include?(:after_incident_actions)
    SaverWorker.perform_async(u_incident&.id)
    u_incident
  end

  def do_not_process_without_address
    return if incident_attrs[:address].present?
    unless  incident_attrs[:latitude].present? && incident_attrs[:longitude].present?
      self.should_create_incident = false
    end
  end

  module ClassMethods
    def find_or_new_from_external_api(h)
      hash = ActiveSupport::HashWithIndifferentAccess.new(h)
      id = self.id_from_external_hash(hash)
      obj = self.where(external_api_id: id).first if id.present?
      if obj.present?
        if obj.external_api_updated_at.present? && obj.processed
          return nil unless obj.external_api_updated_at < obj.hash_updated_at(hash)
        end
      else
        obj = self.new(external_api_id: id) 
      end
      obj.external_api_hash = hash
      obj.processed = false
      obj.external_api_checked_at = Time.now
      obj
    end
  end

end