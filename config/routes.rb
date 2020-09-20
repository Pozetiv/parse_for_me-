Rails.application.routes.draw do
  resources :banks, only: %i[index show] do
    resources :report_datums, only: :destroy do
      collection do
        get :do_update
      end
    end
  end

  root to: 'banks#index'
end
