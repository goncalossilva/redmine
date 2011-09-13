
Redmine::Application.routes.draw do
  root :to => 'welcome#index', :as => 'home'

  match '/login' => 'account#login', :as => 'signin'
  match '/logout' => 'account#logout', :as => 'signout'

  match '/register' => 'account#register', :as => 'register'
  match '/lost_password' => 'account#lost_password', :as => 'lost_password'


  match '/my/account' => 'my#account', :as => 'my_account'
  match '/my/page' => 'my#page', :as => 'my_page'
  match '/my/page_layout' => 'my#page_layout', :as => 'my_page_layout'

  match '/search' => 'search#index', :as => 'search'

  match '/admin' => 'admin#index', :as => 'admin'

  match '/help/wiki_syntax' => 'help#wiki_syntax', :as => 'help_wiki_syntax'


  match '/versions/:id' => 'versions#show', :as => 'version'
  match '/versions/edit/:id' => 'versions#edit', :as => 'edit_version'
  match '/versions/destroy/:id' => 'versions#destroy', :as => 'destroy_version'
  match '/versions/close_completed_versions/:id' => 'versions#close_completed', :as => 'close_completed_project_versions'


  match '/queries/new' => 'queries#new', :as => 'new_query'

  match '/watchers/watch' => 'watchers#watch', :as => 'watcher_watch'
  match '/watchers/new' => 'watchers#new', :as => 'new_watcher'


  match '/time_entries' => 'time_entries#index', :as => 'time_entries'



  match '/roles/workflow/:id/:role_id/:tracker_id' => 'roles#workflow'
  match '/help/:ctrl/:page' => 'help#index'

  scope :controller => 'time_entry_reports', :action => 'report', :via => :get do
    match '/projects/:project_id/issues/:issue_id/time_entries/report(.:format)'
    match '/projects/:project_id/time_entries/report(.:format)'
    match '/time_entries/report(.:format)'
  end

  resources :time_entries, :controller => 'timelog'

  match '/projects/:id/wiki' => 'wikis#edit', :via => :post
  match '/projects/:id/wiki/destroy' => 'wikis#destroy', :via => [:get, :post]

  scope :controller => 'messages' do
    scope :via => :get do
      match '/boards/:board_id/topics/new', :action => :new
      match '/boards/:board_id/topics/:id', :action => :show
      match '/boards/:board_id/topics/:id/edit', :action => :edit
    end
    scope :via => :post do
      match '/boards/:board_id/topics/new', :action => :new
      match '/boards/:board_id/topics/:id/replies', :action => :reply
      match '/boards/:board_id/topics/:id/:action', :action => /edit|destroy/
    end
  end

  scope :controller => 'boards' do
    scope :via => :get do
      match '/projects/:project_id/boards', :action => :index
      match '/projects/:project_id/boards/new', :action => :new
      match '/projects/:project_id/boards/:id(.:format)', :action => :show
      match '/projects/:project_id/boards/:id/:edit', :action => :edit
    end
    scope :via => :post do
      match '/projects/:project_id/boards', :action => :new
      match '/projects/:project_id/boards/:id/:action', :action => /edit|destroy/
    end
  end

  scope :controller => 'documents' do
    scope :via => :get do
      match '/projects/:project_id/documents', :action => :index
      match '/projects/:project_id/documents/new', :action => :new
      match '/documents/:id', :action => :show
      match '/documents/:id/:edit', :action => :edit
    end
    scope :via => :post do
      match '/projects/:project_id/documents', :action => :new
      match '/documents/:id/:action', :action => /edit|destroy/
    end
  end

  scope '/issues' do
    resources :issue_moves, :only => [:new, :create], :as => 'move'
  end

  # Misc issue routes. TODO: move into resources
  match '/issues/auto_complete' => 'auto_completes#issues', :as => 'auto_complete_issues'
  match '/issues/preview/:id' => 'previews#issue', :as => 'preview_issue' # TODO: would look nicer as /issues/:id/preview
  match '/issues/context_menu' => 'context_menus#issues', :as => 'issues_context_menu'
  match '/issues/changes' => 'journals#index', :as => 'issue_changes'
  match '/issues/bulk_edit' => 'issues#bulk_edit', :via => :get, :as => 'bulk_edit_issue'
  match '/issues/bulk_edit' => 'issues#bulk_update', :via => :post, :as => 'bulk_update_issue'
  match '/issues/:id/quoted' => 'journals#new', :id => /\d+/, :via => :post, :as => 'quoted_issue'
  match '/issues/:id/destroy' => 'issues#destroy', :via => :post # legacy

  scope '/issues' do
    resource :gantt, :only => [:show, :update]
    resource :calendar, :only => [:show, :update]
  end
  scope '/projects/:project_id/issues' do
    resource :gantt, :only => [:show, :update]
    resource :calendar, :only => [:show, :update]
  end

  scope :controller => 'reports', :via => :get do
    match '/projects/:id/issues/report', :action => 'issue_report'
    match '/projects/:id/issues/report/:detail', :action => 'issue_report_details'
  end

  # Following two routes conflict with the resources because #index allows POST
  match '/issues' => 'issues#index', :via => :post
  match '/issues/create' => 'issues#index', :via => :post

  resources :issues do
    post :edit, :on => :member
    resources :time_entries, :controller => 'timelog'
  end

  scope '/projects/:project_id' do
    resources :issues do
      post :create, :on => :collection
      resources :time_entries, :controller => 'timelog'
    end
  end

  scope :controller => 'issue_relations', :via => :post do
    match '/issues/:issue_id/relations/:id', :action => 'new'
    match '/issues/:issue_id/relations/:id/destroy', :action => 'destroy'
  end

  match '/projects/:id/members/new' => 'members#new'

  scope :controller => 'users' do
    match '/users/:id/edit/:tab', :action => 'edit', :via => :get

    scope :via => :post do
      match '/users/:id/memberships', :action => 'edit_membership'
      match '/users/:id/memberships/:membership_id', :action => 'edit_membership'
      match '/users/:id/memberships/:membership_id/destroy', :action => 'destroy_membership'
    end
  end

  resources :users, :except => :destroy do
    member do
      post :edit_membership
      post :destroy_membership
    end
  end

  # For nice "roadmap" in the url for the index action
  match '/projects/:project_id/roadmap' => 'versions#index'

  match '/news' => 'news#index', :as => 'all_news'
  match '/news.:format' => 'news#index', :as => 'formatted_all_news'
  match '/news/preview' => 'previews#news', :as => 'preview_news'
  match '/news/:id/comments' => 'comments#create', :via => :post
  match '/news/:id/comments/:comment_id' => 'comments#destroy', :via => :delete

  resources :projects do
    member do
      match :copy, :via => [:get, :post]
      get :settings
      post :modules
      post :archive
      post :unarchive
    end

    resource :project_enumerations, :as => 'enumerations', :only => [:update, :destroy]
    resources :files, :only => [:index, :new, :create]
    resources :versions do
      member do
        post :status_by
      end
      collection do
        put :closed_completed
      end
    end
    resources :news, :shallow => true
    resources :time_entries, :controller => 'timelog'

    match '/wiki' => 'wiki#show', :via => :get, :as => 'wiki_start_page'
    match '/wiki/index' => 'wiki#index', :via => :get, :as => 'wiki_index'
    match '/wiki/:id/diff/:version' => 'wiki#diff', :as => 'wiki_diff'
    match '/wiki/:id/diff/:version/vs/:version_from' => 'wiki#diff', :as =>  'wiki_diff'
    match '/wiki/:id/annotate/:version' => 'wiki#annotate', :as => 'wiki_annotate'
    resources :wiki, :except => [:new, :create] do
      member do
        match :rename, :via => [:get, :post]
        get :history
        match :preview
        post :protect
        post :add_attachment
      end
      collection do
        get :export
        get :date_index
      end
    end
  end

  # Destroy uses a get request to prompt the user before the actual DELETE request
  match '/projects/:id/destroy' => 'projects#destroy', :via => :get

  # TODO: port to be part of the resources route(s)
  scope :via => :get do
    match '/projects/:id/settings/:tab' => 'projects#settings'
    match '/projects/:project_id/issues/:copy_from/copy' => 'issues#new'
  end

  scope :controller => 'activities', :action => 'index', :via => :get do
    match '/projects/:id/activity(.:format)'
    match '/activity(.:format)'
  end

  match '/projects/:project_id/issue_categories/new' => 'issue_categories#new'

  scope :controller => 'repositories' do
    scope :via => :get do
      match '/projects/:id/repository', :action => 'show'
      match '/projects/:id/repository/edit', :action => 'edit'
      match '/projects/:id/repository/statistics', :action => 'stats'
      match '/projects/:id/repository/revisions(.:format)', :action => 'revisions'
      match '/projects/:id/repository/revisions/:rev', :action => 'revision'
      match '/projects/:id/repository/revisions/:rev/diff(.:format)', :action => 'diff'
      match '/projects/:id/repository/revisions/:rev/raw/*path', :action => 'entry', :format => 'raw', :rev => /[a-z0-9\.\-_]+/
      match '/projects/:id/repository/revisions/:rev/:action/*path', :rev => /[a-z0-9\.\-_]+/
      match '/projects/:id/repository/raw/*path', :action => 'entry', :format => 'raw'
      # TODO: why the following route is required?
      match '/projects/:id/repository/entry/*path', :action => 'entry'
      match '/projects/:id/repository/:action/*path'
    end
    match '/projects/:id/repository/:action', :via => :post
  end

  match '/attachments/:id' => 'attachments#show', :id => /\d+/
  match '/attachments/:id/:filename' => 'attachments#show', :id => /\d+/, :filename => /.*/
  match '/attachments/download/:id/:filename' => 'attachments#download', :id => /\d+/, :filename => /.*/
  match '/attachments/destroy/:id' => 'attachments#destroy', :as => 'destroy_attachment'

  resources :groups

  #left old routes at the bottom for backwards compat
  match '/projects/:project_id/issues/:action', :controller => 'issues'
  match '/projects/:project_id/documents/:action', :controller => 'documents'
  match '/projects/:project_id/boards/:action/:id', :controller => 'boards'
  match '/boards/:board_id/topics/:action/:id', :controller => 'messages'
  match '/wiki/:id/:page/:action', :controller => 'wiki'
  match '/issues/:issue_id/relations/:action/:id', :controller => 'issue_relations'
  match '/projects/:project_id/news/:action', :controller => 'news'
  match '/projects/:project_id/timelog/:action/:id', :controller => 'timelog', :project_id => /.+/
  scope :controller => 'repositories' do
    match '/repositories/browse/:id/*path', :action => 'browse', :as => 'repositories_show'
    match '/repositories/changes/:id/*path', :action => 'changes', :as => 'repositories_changes'
    match '/repositories/diff/:id/*path', :action => 'diff', :as => 'repositories_diff'
    match '/repositories/entry/:id/*path', :action => 'entry', :as => 'repositories_entry'
    match '/repositories/annotate/:id/*path', :action => 'annotate', :as => 'repositories_entry'
    match '/repositories/revision/:id/:rev', :action => 'revision'
  end

  scope :controller => 'sys' do
    match '/sys/projects.:format', :action => 'projects', :via => :get
    match '/sys/projects/:id/repository.:format', :action => 'create_project_repository', :via => :post
  end

  match '/robots.txt' => 'welcome#robots'

  # Used for OpenID
  root :to => 'account#login'
end
