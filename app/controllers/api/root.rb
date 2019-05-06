require 'grape_logging'

module GrapeLogging
  module Loggers
    class BinxLogger < GrapeLogging::Loggers::Base
      def parameters(request, _)
        { remote_ip: request.env['HTTP_CF_CONNECTING_IP'], format: 'json' }
      end
    end
  end
end

module API
  class Dispatch < Grape::API
    use GrapeLogging::Middleware::RequestLogger, instrumentation_key: 'grape_key',
                                                 include: [GrapeLogging::Loggers::BinxLogger.new,
                                                           GrapeLogging::Loggers::FilterParameters.new]
    mount API::V1::Root
    mount API::V2::Root
    format :json
    route :any, '*path' do
      Rack::Response.new({message: "Not found"}.to_json, 404).finish
    end
  end

  Root = Rack::Builder.new do
    use API::Logger
    run API::Dispatch
  end
end