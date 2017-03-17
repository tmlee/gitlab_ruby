module GitlabRuby
  class APIObject < Hash
    def initialize(data)
      super()
      data.each { |key, val| self[key] = val } if data.is_a?(Hash)
    end

    def format(val)
      return if val.nil?
      if val.class == Hash
        APIObject.new(val)
      else
        val
      end
    end

    def method_missing(method, *args, &blk)
      format(self[method.to_s]) || super
    end

    def respond_to_missing?(method, include_all = false)
      key?(method.to_s) || super
    end
  end
end
