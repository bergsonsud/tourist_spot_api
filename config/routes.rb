Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'tourist_spots/search', to: 'tourist_spots#search'
    end
  end
end
