module GitlabRuby
  class QueryChain
    attr_accessor :urlstring
    attr_accessor :verb

    def initialize(params = {})
      @verb = params[:verb]
      @client = params[:client]
      @urlstring = ''
    end

    def execute(params = {})
      @client.api_call(@urlstring, params, @verb)
    end

    class << self
      def generate_methods
        CSV.foreach('lib/gitlab_ruby/routes_table_no_verb.csv') do |url_row|
          query_stacks =  GitlabRuby::Helpers::QueryChain
                          .to_query_stacks(url_row.first)
          query_stacks.each_with_index do |key|
            key = key.match(/{(.+)}/)[1] if key.match(/{.+}/)
            build_method(key)
          end
        end
      end

      private

      def build_method(key)
        define_method key do |*param|
          if param.size == 1
            @urlstring = @urlstring + param[0].to_s + '/'
          elsif param.size.zero?
            @urlstring = @urlstring + key + '/'
          else
            raise GitlabRuby::QueryChainArgumentError
          end
          self
        end
      end
    end
  end
end
