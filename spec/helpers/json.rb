module Helpers
  module Json
    def json
      HashWithIndifferentAccess[JSON.parse(response.body)]
    end

    def sign_in_as(user=:manager)
      user_params = attributes_for(user)
      user.to_s.classify.constantize.create(user_params)
      post "/api/v1/#{user.to_s.pluralize}/sign_in", user => user_params
      json[:token]
    end
  end
end
