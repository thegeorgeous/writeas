# lib/response.rb

module Writeas
  class Response
    attr_reader :code

    def initialize(response_body)
      parsed_body = JSON.parse(response_body)
      @code = parsed_body["code"]
      @data = parsed_body["data"]
    end
  end
end
