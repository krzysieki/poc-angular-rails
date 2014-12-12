Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :users
    end
  end

end
