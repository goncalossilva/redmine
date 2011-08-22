Redmine::Application.routes.draw do
  root :to => 'welcome#index'

  match '/login', :to => 'account#login', :as => :signin
  match '/logout', :to => 'account#logout', :as => :signout

  match '/roles/workflow/:id/:role_id/:tracker_id', :to => 'roles#workflow'
  match '/help/:ctrl/:page', :to => 'help#index'

  match '(projects/:project_id/(issues/:issue_id/))time_entries/report(.:format)', :to => "time_entry_reports#report", :via => [:get]

  resources :time_entries, :to => 'timelog'

  controller 'wikis' do
    match 'projects/:id/wiki' => :edit, :via => [:post]
    match 'projects/:id/wiki/destroy' => :destroy, :via => [:get, :post]
  end

  controller "messages" do
    scope 'boards/:board_id/topics', :via => [:get] do
      match 'new' => :new
      match ':id' => :show
      match ':id/edit' => :edit
    end
    scope 'boards/:board_id/topics', :via => [:post] do
      match 'new' => :new
      match ':id' => :reply
      match ':id/:action'
    end
  end

  controller 'boards' do
    scope 'projects/:project_id/boards', :via => [:get] do
      root :to => :index
      match 'new' => :new
      match ':id(.:format)' => :show
      match ':id/edit' => :edit
    end
    post 'projects/:project_id/boards' => :new
    post 'projects/:project_id/boards/:id/:action'
  end

  controller 'documents' do
    scope '(projects/:project_id/)documents', :via => [:get] do
      root :to => :index
      match 'new' => :new
      match ':id' => :show
      match ':id/edit' => :show
    end
    post 'projects/:project_id/documents' => :new
    post '(projects/:project_id/)documents/:id/:action'
  end

  scope 'issues' do
    resources :issue_moves, :only => [:new, :create], :as => 'move'

    # # Misc issue routes. TODO: move into resources
    match 'auto_complete', :to => 'auto_completes#issues', :as => 'auto_complete_issues'
    match 'preview/:id', :to => 'previews#issue', :as => 'preview_issue'
    match 'context_menu', :to => 'context_menus#issues', :as => 'issues_context_menu'
    controller 'journals' do
      match 'changes' => :index, :as => 'issue_changes'
      post ':id/quoted' => :new, :id => /\d+/, :as => 'quoted_issue'
    end
    controller 'issues' do
      get 'bulk_edit' => :bulk_edit, :as => 'bulk_edit_issue'
      post 'bulk_edit' => :bulk_update, :as => 'bulk_update_issue'
      post ':id/destroy' => :destroy # legacy
    end

    resources :gantt, :only => [:show, :update]
    resources :calendar, :only => [:show, :update]
  end

  scope 'projects/:project_id/issues' do
    resources :gantt, :only => [:show, :update]
    resources :calendar, :only => [:show, :update]
  end

  controller 'reports', :via => [:get] do
    scope 'projects/:id/issues' do
      match 'report' => :issue_report
      match 'report/:detail' => :issue_report_details
    end
  end

  controller 'issues' do
    post 'issues' => :index
    post 'issues/create' => :index
  end

  scope '(projects/:project_id/)' do
    resources :issues do
      collection do
        post :create
      end
      controller :timelog do
        resources :time_entries
      end
    end
  end

  controller :issue_relations, :via => [:post] do
    scope 'issues/:issue_id/relations' do
      match ':id' => :new
      match ':id/destroy' => :destroy
    end
  end

  match 'projects/:id/members/new', :to => 'members#new'

  controller :users do
    scope 'users/:id' do
      get 'edit/:tab' => :edit, :tab => nil
      post 'memberships' => :edit_membership
      post 'memberships/:membership_id' => :edit_membership
      post 'memberships/:membership_id/destroy' => :destroy_membership
    end
  end

  resources :users, :member, :except => [:destroy] do
    post :edit_membership
    post :destroy_membership
  end

  # For nice "roadmap" in the url for the index action
  match 'projects/:project_id/roadmap', :to => 'versions#index'

  match 'news', :to => 'news#index', :as => 'all_news'
  match 'news.:format', :to => 'news#index', :as => 'formatted_all_news'
  match 'news/preview', :to => 'previews#news', :as => 'preview_news'
  post 'news/:id/comments', :to => 'comments#create'
  delete 'news/:id/comments/:comment_id', :to => 'comments#destry'

  # map.resources :projects, :member => {
  #   :copy => [:get, :post],
  #   :settings => :get,
  #   :modules => :post,
  #   :archive => :post,
  #   :unarchive => :post
  # } do |project|
  #   project.resource :project_enumerations, :as => 'enumerations', :only => [:update, :destroy]
  #   project.resources :files, :only => [:index, :new, :create]
  #   project.resources :versions, :collection => {:close_completed => :put}, :member => {:status_by => :post}
  #   project.resources :news, :shallow => true
  #   project.resources :time_entries, :controller => 'timelog', :path_prefix => 'projects/:project_id'

  #   project.wiki_start_page 'wiki', :controller => 'wiki', :action => 'show', :conditions => {:method => :get}
  #   project.wiki_index 'wiki/index', :controller => 'wiki', :action => 'index', :conditions => {:method => :get}
  #   project.wiki_diff 'wiki/:id/diff/:version', :controller => 'wiki', :action => 'diff', :version => nil
  #   project.wiki_diff 'wiki/:id/diff/:version/vs/:version_from', :controller => 'wiki', :action => 'diff'
  #   project.wiki_annotate 'wiki/:id/annotate/:version', :controller => 'wiki', :action => 'annotate'
  #   project.resources :wiki, :except => [:new, :create], :member => {
  #     :rename => [:get, :post],
  #     :history => :get,
  #     :preview => :any,
  #     :protect => :post,
  #     :add_attachment => :post
  #   }, :collection => {
  #     :export => :get,
  #     :date_index => :get
  #   }

  # end

  # Destroy uses a get request to prompt the user before the actual DELETE request
  get 'projects/:id/destroy', :to => 'projects#destroy',:as => 'project_destroy_confirm'
  # TODO: port to be part of the resources route(s)
  scope 'projects', :via => [:get] do
    match ':id/settings/:tab', :to => "projects#settings"
    match ':project_id/issues/:copy_from/copy' => "issues#new"
  end

  get '(projects/:id/)activity(.:format)', :to => "activities#index"

  match 'projects/:project_id/issue_categories/new', :to => 'issue_categories#new'

  controller :repositories do
    scope 'projects/:id/repository' do
      root :to => :show
      get 'edit' => :edit
      get 'statistics' => :statistics
      get 'revisions(.:format)(/:rev)' => :revisions
      get 'revisions/:rev/diff(.:format)' => :diff
      get 'revisions/:rev/raw/*path' => :entry, :format => :raw, :rev => /[a-z0-9\.\-_]+/
      get 'revisions/:rev/:action/*path' => :entry, :format => :raw, :rev => /[a-z0-9\.\-_]+/
      get 'raw/*path' => :entry, :format => :raw
      # TODO: why the following route is required?
      get 'entry/*path' => :entry
      get ':action/*path'

      post ':action'
    end
  end

  scope 'attachments/:id', :id => /\d+/ do
    controller :attachments do
      match '(:filename)' => :show
    end
  end
  match 'attachments/download/:id/:filename', :to => 'attachments#download', :id => /\d+/

  resources :groups

  controller :sys do
    get 'sys/projects.:format' => :projects
    post 'sys/projects/:id/repository.:format' => :create_project_repository
  end

  # Install the default route as the lowest priority.
  match '/:controller(/:action(/:id))'
  match 'robots.txt', :to => 'welcome#robots'
  # Used for OpenID
  root :to  => 'account#login'
end
