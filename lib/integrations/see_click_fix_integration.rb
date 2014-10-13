require 'httparty'
class SeeClickFixIntegration

  def get_request(params)
    response = HTTParty.get("https://seeclickfix.com/api/v2/#{params}",
      :headers => { 'Content-Type' => 'application/json' } )
    JSON.parse(response.body)
  end

  def get_issues_page(page)
    issues_page = get_request("issues?page=#{page}&per_page=50")
    return nil if page > issues_page['metadata']['pagination']['pages']
    issues_page
  end

  def make_reports_from_issues_page(issues_page)
    issues = issues_page['issues']
    issues.each do |issue|
      scf_report = ScfReport.find_or_new_from_external_api(issue)
      scf_report.save
    end
  end

  def last_issue_updated_at(issues_page)
    last_issue = issues_page['issues'].last
    Time.parse(last_issue['updated_at'])
  end

  def get_issues_and_make_reports(page)
    issues_page = get_issues_page(page)
    make_reports_from_issues_page(issues_page)
    issues_page['metadata']['pagination']['pages']
  end

end