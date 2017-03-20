require 'strscan'

module GitlabRuby
  class PaginatedResponse
    def initialize(params = {})
      @client = params[:client]
      @array = params[:array]
      @page_links = parse_page_links_from(params[:headers])
    end

    def next_page?
      return nil unless @page_links['next']
      true
    end

    def prev_page?
      return nil unless @page_links['prev']
      true
    end

    def next_page
      return nil unless next_page?
      fetch(@page_links['next'][:href])
    end

    def prev_page
      return nil unless prev_page?
      fetch(@page_links['prev'][:href])
    end

    def last_page
      fetch(@page_links['last'][:href])
    end

    def first_page
      fetch(@page_links['first'][:href])
    end

    ## Treat this like an Array (START)
    #
    def ==(other)
      @array == other
    end

    def inspect
      @array.inspect
    end

    def method_missing(name, *args, &block)
      if @array.respond_to?(name)
        @array.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || @array.respond_to?(method_name, include_private)
    end
    #
    ## Treat this like an Array (ENDS)

    private

    HREF   = / *< *([^>]*) *> *;? */                  #:nodoc: note: no attempt to check URI validity
    TOKEN  = /([^()<>@,;:\"\[\]?={}\s]+)/             #:nodoc: non-empty sequence of non-separator characters
    QUOTED = /"((?:[^"\\]|\\.)*)"/                    #:nodoc: double-quoted strings with backslash-escaped double quotes
    ATTR   = /#{TOKEN} *= *(#{TOKEN}|#{QUOTED}) */    #:nodoc:
    SEMI   = /; */                                    #:nodoc:
    COMMA  = /, */                                    #:nodoc:

    def fetch(href)
      query_chain = GitlabRuby::QueryChain.new(client: @client, verb: :get)
      query_chain.urlstring = href
      query_chain.execute
    end

    def parse_page_links_from(headers)
      # Example {"link"=>"<https://gitlab.com/api/v4/projects?archived=false&membership=false&order_by=created_at&owned=false&page=2&per_page=20&simple=false&sort=desc&starred=false>; rel=\"next\", <https://gitlab.com/api/v4/projects?archived=false&membership=false&order_by=created_at&owned=false&page=1&per_page=20&simple=false&sort=desc&starred=false>; rel=\"first\", <https://gitlab.com/api/v4/projects?archived=false&membership=false&order_by=created_at&owned=false&page=13086&per_page=20&simple=false&sort=desc&starred=false>; rel=\"last\"", "vary"=>"Origin", "x-next-page"=>"2", "x-page"=>"1", "x-per-page"=>"20", "x-prev-page"=>"", "x-request-id"=>"eb9bd5b4-5ca9-441b-ac8e-8a6bc99d1684", "x-runtime"=>"9.262252", "x-total"=>"261707", "x-total-pages"=>"13086", "strict-transport-security"=>"max-age=31536000"}
      scanner = StringScanner.new(headers['link'])
      links = {}
      while scanner.scan(HREF)
        href = scanner[1]
        attrs = []
        while scanner.scan(ATTR)
          attr_name = scanner[1]
          token = scanner[3]
          quoted = scanner[4]
          attrs.push([attr_name, token || quoted.gsub(/\\"/, '"')])
          puts attrs
          break unless scanner.scan(SEMI)
        end
        links[attrs[0].last] = { href: href, attrs: attrs }
        break unless scanner.scan(COMMA)
      end
      links
    end
  end
end
