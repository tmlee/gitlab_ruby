module GitlabRuby
  def self.format_error(resp)
    resp.body
  end

  def self.check_response_status(resp)
    if resp.body
      case resp.status
      when 400 then raise BadRequestError, format_error(resp)
      when 401 then raise UnauthorizedError, format_error(resp)
      when 403 then raise ForbiddenError, format_error(resp)
      when 404 then raise NotFoundError, format_error(resp)
      when 405 then raise MethodNotAllowedError, format_error(resp)
      when 409 then raise ConflictError, format_error(resp)
      when 422 then raise UnprocessableError, format_error(resp)
      when 500 then raise ServerError, format_error(resp)
      end
    end

    if resp.status > 400
      raise APIError, "[#{resp.status}] #{resp.body}"
    end
  end

  class APIError < RuntimeError
  end

  # Status 400
  class BadRequestError < APIError
  end

  # Status 401
  class UnauthorizedError < APIError
  end

  # Status 403
  class ForbiddenError < APIError
  end

  # Status 404
  class NotFoundError < APIError
  end

  # Status 405
  class MethodNotAllowedError < APIError
  end

  # Status 409
  class ConflictError < APIError
  end

  # Status 422
  class UnprocessableError < APIError
  end

  # Status 500
  class ServerError < APIError
  end
end
