module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do 
        version 'v1'
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        rescue_from ActiveRecord::RecordNotFound do |e|
          Rack::Response.new({message: e.message}.to_json, 404).finish
        end

        rescue_from :all do |e|
          Rack::Response.new({
            # error: "internal-server-error",
            message: "#{e.message}",
            trace: e.backtrace[0,10]
          }.to_json, 500).finish
        end

      end
    end
  end
end