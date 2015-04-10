class DocumentationController < ApplicationController

  def index
    redirect_to controller: :documentation, action: :api_v2
  end

  def api_v1
    redirect_to controller: :documentation, action: :api_v2
  end

  def api_v2
    render layout: false
  end

end