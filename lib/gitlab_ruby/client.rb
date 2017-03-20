module GitlabRuby
  class Client
    BASE_URL = "https://gitlab.com/api/"
    LATEST_VERSION = 'v4'

    def initialize(params={})
      @token = params[:token]
      @urlstring = ""
      @endpoint = params[:endpoint] || BASE_URL
      @version = params[:version] || LATEST_VERSION
    end

    def self.debug
      @debug ||= false
    end

    def self.debug=(v)
      @debug = !!v
    end

    def put
      GitlabRuby::QueryChain.new(client: self, verb: :put)
    end

    def post
      GitlabRuby::QueryChain.new(client: self, verb: :post)
    end

    def get
      GitlabRuby::QueryChain.new(client: self, verb: :get)
    end

    def delete
      GitlabRuby::QueryChain.new(client: self, verb: :delete)
    end

    def api_call(method_name, options, verb=:get)
      response = connection(method_name, options, verb)
      puts response.inspect if self.class.debug
      result = parse_response(response)
      if result.is_a? Array
        GitlabRuby::PaginatedResponse.new(
          client: self,
          array: result.map { |item| APIObject.new(item) },
          headers: response.headers
        )
      elsif result.is_a? Hash
        APIObject.new(result)
      end
    end

    private

    def versioned_url
      BASE_URL + @version + "/"
    end

    def parse_response(response)
      if response.status.to_i >= 400
        GitlabRuby::check_response_status(response)
      else
        JSON.parse(response.body)
      end
    end

    def connection(method_name, options, verb)
      conn = Faraday.new(url: versioned_url) do |faraday|
        faraday.request  :url_encoded
        faraday.response(:logger) if self.class.debug
        faraday.adapter  Faraday.default_adapter
        faraday.headers['User-Agent'] = "GitlabRuby gem v#{VERSION}"
        faraday.headers['PRIVATE-TOKEN'] = @token
      end

      case verb
        when :put then conn.put(method_name, options)
        when :post then conn.post(method_name, options)
        when :delete then conn.delete(method_name, options)
        else conn.get(method_name, options)
      end
    end
  end
end
