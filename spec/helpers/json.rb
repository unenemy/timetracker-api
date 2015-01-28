module Helpers
  module Json
    def json
      HashWithIndifferentAccess[JSON.parse(response.body)]
    end
  end
end
