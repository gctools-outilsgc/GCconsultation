# MOD
namespace :test do
  root to: "dashboard#index"

  namespace :legislation do
    resources :processes do
      resources :questions
      resources :proposals do
        member { patch :toggle_selection }
      end
      resources :draft_versions
      resources :milestones
      resource :homepage, only: [:edit, :update]
    end
  end

end
# END OF MOD