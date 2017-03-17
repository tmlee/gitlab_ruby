module GitlabRuby
  module Errors
    class QueryChainArgumentError < StandardError
      def initialize
        super("Can only pass ONE parameter at most")
      end
    end
  end
end
