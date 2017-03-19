module GitlabRuby
  module Helpers
    module QueryChain
      MUSTERMANN_TEMPLATE_KEY_REGEX = %r(\.|\/)

      def self.to_query_stacks(url_row)
        query_stacks = Mustermann.new(url_row)
                                 .to_templates
                                 .first
                                 .split(MUSTERMANN_TEMPLATE_KEY_REGEX)
        query_stacks.map { |query| query if query.size > 1 }.compact
      end
    end
  end
end
