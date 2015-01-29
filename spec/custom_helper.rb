module CustomHelper
  def json
    JSON.parse(response.body)
  end

  def sign_in_as(user)
    user_params = attributes_for(user)
    user.to_s.classify.constantize.create(user_params)
    post "/api/v1/#{user.to_s.pluralize}/sign_in", user => user_params
    @token = json['token']
  end

  [:post, :get, :delete, :patch].each do |method|
    define_method method do |*args|
      args[2] = (args[2] || {}).merge({'Authorization' => "Token: token=#{@token}"}) if @token
      super(*args)
    end
  end
end
