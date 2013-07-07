Propile::Application.routes.draw do

  resources :archived_presenters

  resources :program_entries

  resources :programs do
    resources :program_entries, :on => :member
    get 'copy', :on => :member
    get 'calculate_paf', :on => :member
    get 'csv', :on => :member
    get 'materials_csv', :on => :member
    put 'insertSlot', :on => :member
    put 'insertTrack', :on => :member
    put 'removeSlot', :on => :member
    put 'removeTrack', :on => :member
    get 'program_board_cards', :on => :member
    get 'export', :on => :member
    get 'preview', :on => :member
  end

  resources :propile_configs do
    put 'toggle', :on => :collection
    put 'change_last_login', :on => :collection
    put 'toggle_send_mails', :on => :collection
    get 'start_conference', :on => :collection
  end

  resources :votes do
    get 'csv', :on => :collection
  end

  resources :pages, :only => :show
  
  resources :accounts

  resources :comments


  resources :presenters do
    put 'toggle_maintainer_role', :on => :member
    get 'export', :on => :collection
    get 'dashboard', :on => :collection
  end

  resources :reviews do
    resources :comments, :on => :member
  end

  resources :sessions do
    resources :reviews, :on => :member
    resources :votes, :on => :member 
    get 'thanks', :on => :member
    get 'csv', :on => :collection
    get 'pcm_cards', :on => :collection
    get 'program_board_card', :on => :member
    get 'rss' , :on => :member
    get 'activity_rss' , :on => :collection
  end

  namespace :account do
    resource :session, :only => [:new, :create, :destroy]
    resources :response_sessions, :only => [:show]
    resource :password, :only => [:edit, :update]
    resource :password_reset, :only => [:new, :create] do
      get 'success'
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
