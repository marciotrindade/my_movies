Movies::Application.routes.draw do
  namespace :admin do
    root :to => "pages#home"
    resources :pages, :except => [:show]
    resources :roles, :except => [:show]
    resources :administrators, :except => [:show]
    resources :users, :except => [:show] do
      put :update_profile, :on => :member
      collection do
        get :profile
      end
    end
  end

  # login
  devise_for :users
  # root
  root :to => "pages#home"

  # jammit
  match "/#{Jammit.package_path}/:package.:extension", :to => 'jammit#package', :as => :jammit
end
