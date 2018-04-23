Rails.application.routes.draw do
  scope path: 'api/v1' do
    scope except: :destroy do

      resources :transfers do
        member do
          post :reverse
        end
      end

      resources :accounts do
        member do
          post :block
          post :unblock
          post :cancel
        end
      end

      resources :people

    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
