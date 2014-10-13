require 'httparty'
class BikeIndexIntegration

  def get_request(params)
    response = HTTParty.get("https://bikeindex.org/api/v1/#{params}from=bikewise",
      :headers => { 'Content-Type' => 'application/json' } )
    begin
      JSON.parse(response.body)
    rescue
      return nil
    end
  end

  def create_or_update_binx_report(binx_id)
    hash = get_request("bikes/#{binx_id}?")
    return nil unless hash.present?
    binx_report = BinxReport.find_or_new_from_external_api(hash)
    binx_report.save if binx_report.present?
  end

  def get_stolen_bikes_updated_since(time)
    stolen_ids = get_request("bikes/stolen_ids?updated_since=#{time.to_i}&access_token=#{ENV['BIKEINDEX_ACCESS_TOKEN']}&organization_slug=#{ENV['BIKEINDEX_ORG_SLUG']}&")
    stolen_ids["bikes"]
  end

end