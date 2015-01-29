Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, except: [:edit, :new] do
    namespace :v1 do
      concern :authenticable do
        collection do
          post :sign_in
          delete :sign_out
        end
      end

      resources :employees, concerns: :authenticable
      resources :managers, concerns: :authenticable
      resources :timetracks
    end
  end
end
