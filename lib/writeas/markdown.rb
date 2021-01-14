module Writeas
  class Markdown
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end
end
