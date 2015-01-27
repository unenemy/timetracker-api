Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      concern :authenticable do
        collection do
          post :sign_in
          delete :sign_out
        end
      end
      resources :employees, concerns: :authenticable do
        resources :timetracks
      end
      resources :timetracks
      resources :managers, concerns: :authenticable
    end
  end
end
