# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    include JwtAuthorizeUser

    def current_user
      authenticated_user?
    end
  end
end
