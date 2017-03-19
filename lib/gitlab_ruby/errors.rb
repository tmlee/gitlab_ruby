module GitlabRuby
  class QueryChainArgumentError < RuntimeError
    def initialize
      super("Can only pass ONE parameter")
    end
  end
end
