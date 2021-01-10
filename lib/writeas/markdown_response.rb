require_relative './response'

module Writeas
  class MarkdownResponse < Response
    attr_reader :body

    def initialize(response_body)
      super(response_body)
      @body = @data["body"]
    end
  end
end
