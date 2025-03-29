Rails.application.routes.draw do
  # Root route for the login page
  root "sessions#new"

  # Session management routes for login, logout
  resources :sessions, only: [:new, :create, :destroy]
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Employee-specific leave requests (new, create, index)
  resources :leave_requests, only: [:new, :create, :index] do
    collection do
      patch :export # Route for exporting leave requests
    end
  end

  # Admin namespace for HR-specific leave management
  namespace :admin do
    resources :leave_requests, only: [:index] do
      member do
        patch :approve # Approve leave request
        patch :decline # Decline leave request
      end
    end
  end
end
