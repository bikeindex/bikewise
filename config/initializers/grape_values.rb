if Rails.env.test?
  INCIDENT_TYPES = [
    'Unconfirmed',
    'Crash',
    'Hazard',
    'Theft',
    'Infrastructure issue',
    'Chop shop'
  ]
  SELECTION_TYPES = ["gender", "location", "experience_level", "lighting", "visibility", "injury_severity", "condition", "geometry", "crash", "vehicle", "hazard", "priority"]
else
  INCIDENT_TYPES = !!IncidentType && IncidentType.all.pluck(:slug) rescue []
  SELECTION_TYPES = !!Selection &&  Selection.pluck(:select_type).uniq rescue []
end