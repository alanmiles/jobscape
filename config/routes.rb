Jobscape::Application.routes.draw do

  resources :users do
    resource :portrait, :shallow => true
    resources :achievements, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :characteristics, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :favourites, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :dislikes, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :qualifications, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :strengths, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :limitations, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :aims, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :previousjobs, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :references, :shallow => true
  end
  resources :occupations
  resources :sessions, :only => [:new, :create, :destroy]
  resources :sectors
  resources :businesses do
    resources :jobs, :shallow => true
  end
  resources :plans do
    resources :responsibilities, :shallow => true
    resources :requirements, :shallow => true do
      collection do
        post :sort
      end
    end
    resources :jobqualities, :shallow => true do
      collection do
        post :sort
      end
    end  
  end
  resources :outlines, :only => [:show, :edit, :update]
  resources :responsibilities do
    resources :goals, :shallow => true
  end
  resources :evaluations, :only => [:edit, :update]
  resources :qualities do
    resources :pams, :shallow => true
  end
  resources :submitted_qualities 
  resources :submitted_pams
  resources :my_submissions
  resources :attribute_submissions
  resources :attribute_rejections
  resources :vacancies do
    resources :applications, :shallow => true
  end
  resources :applications do
    resources :applicqualities, :shallow => true
    resources :applicresponsibilities, :shallow => true
    resources :applicrequirements, :shallow => true
  end
  namespace :officer do
    resources :businesses, :only => :destroy
    resources :vacancy_details,  :only => :show
  end
  resources :latest_vacancies, :only => :index
  resources :current_vacancies, :only => :index
  
  match '/signup',  		:to => 'users#new'
  match '/signin',  		:to => 'sessions#new'
  match '/signout', 		:to => 'sessions#destroy'
  
  match '/contact', 		:to => 'pages#contact'
  match '/about',   		:to => 'pages#about'
  match '/help',    		:to => 'pages#help'
  match '/admin',   		:to => 'pages#admin_home'
  match '/user_home', 		:to => 'pages#user_home'
  match '/jobseeker_home',	:to => 'pages#jobseeker_home'
  match '/jobsearch_menu',	:to => 'pages#jobsearch_menu'
  match '/officer_home',	:to => 'pages#officer_home'
  match '/employee_home',	:to => 'pages#employee_home'
  match '/select_business', 	:to => 'pages#select_business' 
  match '/biz_selection',	:to => 'pages#biz_selection'
  match '/my_job',		:to => 'pages#my_job'

  root :to => 'pages#home'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
