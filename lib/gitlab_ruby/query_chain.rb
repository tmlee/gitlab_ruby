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
        CSV.foreach("lib/gitlab_ruby/routes_table_no_verb.csv") do |row|
          path = Mustermann.new(row.first)
          # puts path.to_templates
          stacks = path.to_templates.first.split(/(\.|\/)/)
          stacks = stacks.map { |s| s if s.size > 1 }.compact
          stacks.each_with_index do |s, index|
            if index == stacks.size - 1 # LAST
              key = s.match(/{(.+)}/)[1]
              define_method key do |*param|
                if param.size == 1
                  @urlstring = @urlstring + "." + param.to_s
                elsif param.size.zero?
                  @urlstring = @urlstring + key
                else
                  raise GitlabRuby::Errors::QueryChainArgumentError
                end
                self
              end

            elsif s.match(/{.+}/)
              key = s.match(/{(.+)}/)[1]
              define_method key do |*param|
                if param.size == 1
                  @urlstring = @urlstring + param[0].to_s + '/'
                elsif param.size.zero?
                  @urlstring = @urlstring + s + '/'
                else
                  raise GitlabRuby::Errors::QueryChainArgumentError
                end
                self
              end
            else
              define_method s do |*param|
                if param.size == 1
                  @urlstring = @urlstring + param[0].to_s + '/'
                elsif param.size.zero?
                  @urlstring = @urlstring + s + '/'
                else
                  raise GitlabRuby::Errors::QueryChainArgumentError
                end
                self
              end
            end
          end
        end
      end
    end
  end
end
