module Writeas
  class Response
    attr_reader :code, :data

    def initialize(response_body)
      @code = response_body["code"]
      @data = response_body["data"]
    end
  end
end
