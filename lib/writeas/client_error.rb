# lib/client_error.rb

module Writeas
  attr_reader :status

  class ClientError < StandardError
    def initialize(message, status)
      super(message)
      @status = status
    end
  end
end
