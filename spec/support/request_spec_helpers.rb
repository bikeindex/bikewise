# Request spec helpers that are included in all request specs via Rspec.configure (rails_helper)
module RequestSpecHelpers
  def json_headers
    {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
  end

  def json_result
    r = JSON.parse(response.body)
    r.is_a?(Hash) ? r.with_indifferent_access : r
  end
end
