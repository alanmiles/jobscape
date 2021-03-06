Jobscape::Application.routes.draw do

  resources :users do
    resource :portrait, :shallow => true
    resources :placements, :shallow => true
    resources :rehires, :shallow => true
    resources :ambitions, :shallow => true
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
    resources :referees, :shallow => true
  end
  resources :occupations
  resources :sessions, :only => [:new, :create, :destroy]
  resources :invitees
  resources :reference_checks
  resources :sectors
  resources :businesses do
    resources :jobs, :shallow => true
    resources :departments, :shallow => true
    resources :invitations, :shallow => true
    resources :hidden_departments, :shallow => true
    resources :inactive_jobs, :shallow => true
    resources :corporate_plans, :shallow => true
    resources :objectives, :shallow => true
  end
  resources :plans do
    member do
      get 'intro', 'uses', 'writing'
    end
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
  resources :my_contacts
  resources :outlines, :only => [:show, :edit, :update] do
    member do
      get 'role', 'qualities', 'importance'
    end
  end
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
  resources :my_tasks
  resources :my_targets
  resources :history_targets
  resources :vacancies do
    resources :applications, :shallow => true
  end
  resources :applications do
    resources :applicqualities, :shallow => true
    resources :applicresponsibilities, :shallow => true
    resources :applicrequirements, :shallow => true
    member do
      get 'summary'
    end
  end
  resources :bookmarks
  resources :letter_templates
  resources :my_applications
  resources :incomplete_applications
  namespace :officer do
    resources :businesses, :only => :destroy
    resources :vacancy_details,  :only => :show
    resources :employees
    resources :users
    resources :leavers
    resources :reviews
    resources :reviewed_users
    resources :vacancies do
      resources :applications, :shallow => true
    end
    resources :portraits
  end
  resources :jobholders
  resources :latest_vacancies, :only => :index
  resources :current_vacancies, :only => :index
  #resources :aplans do
  #  member do
  #    get 'intro', 'uses', 'writing'
  #  end
  #end
  resources :reviews do
    collection do
      get 'reasons', 'reviewers', 'frequency', 'time', 
    end
    member do
      get 'completed_responsibilities', 'completed_attributes', 'completed_comments'
    end
    resources :reviewqualities, :shallow => true
  end
  resources :self_appraisals
  resources :my_reviews do
    member do
      get 'responsibilities', 'attributes', 'comments'
    end
  end
  resources :current_reviews
  resources :external_reviewers, :only => [:edit, :update]
  resources :no_reviews
  resources :no_appraisals
  resources :review_responses, :only => [:edit, :update]
  resources :reviewer_selections, :only => [:edit, :update]
  resources :department_reviews
  namespace :reviewer do
    resources :reviews
    resources :completed_reviews
    resources :score_responsibilities
    resources :score_attributes
    resources :comments
  end
  resources :notes
  resources :contents
  
  
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
  match '/employee_selection',  :to => 'pages#employee_selection'
  match '/my_job',		:to => 'pages#my_job'
  match '/admin_to_standard',   :to => 'pages#admin_to_standard'
  match '/standard_to_admin',	:to => 'pages#standard_to_admin'
  match '/officer_to_own',	:to => 'pages#officer_to_own'
  match '/own_to_officer',	:to => 'pages#own_to_officer'
  match '/hygwit_introduction', :to => 'pages#hygwit_introduction'
  match '/performance_reviews', :to => 'pages#performance_reviews'
  match '/locked_aplan',	:to => 'pages#locked_aplan'
  match '/reviewer_login',	:to => 'pages#reviewer_login'
  match '/recruitment_menu',	:to => 'pages#recruitment_menu'
  match '/personal_goals',	:to => 'pages#personal_goals'
  match '/consultancy',		:to => 'pages#consultancy'
  
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
