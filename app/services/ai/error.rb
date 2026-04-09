module Ai
  class Error < StandardError
    attr_reader :status, :type

    def initialize(message = nil, status: nil, type: nil)
      @status = status
      @type = type
      super(message)
    end
  end
end
