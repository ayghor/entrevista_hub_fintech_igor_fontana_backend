Rails.application.routes.draw do
  scope path: 'api/v1' do
    scope except: :destroy do

      resources :transfers, except: %i(update destroy)

      resources :accounts do
        member do
          post :block
          post :unblock
          post :cancel
          post :uncancel
        end
        resources :transfers, only: :index
      end

      resources :people do
        resources :accounts, only: :index
      end

    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
