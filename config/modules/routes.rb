mod = "webdb"
ZomekiCMS::Application.routes.draw do
  ## admin
  scope "#{ZomekiCMS::ADMIN_URL_PREFIX}/#{mod}/c:concept", :module => mod, :as => mod do
    resources :content_base,
      :controller => 'admin/content/base'

    resources :content_settings, :only => [:index, :show, :edit, :update],
      :controller => 'admin/content/settings',
      :path       => ':content/content_settings'

  #  ## contents
    resources(:dbs,
      :controller => 'admin/dbs',
      :path       => ':content/dbs') do
      resources :items,
        :controller => 'admin/items'
      resources :entries,
        :controller => 'admin/entries'

      end

    ## nodes
    resources :node_dbs,
      :controller => 'admin/node/dbs',
      :path       => ':parent/node_dbs'

    ## pieces
    resources :piece_titles,
      :controller => 'admin/piece/dbs'
  end


  ## public
  scope "_public/#{mod}", :module => mod, :as => '' do
    get 'node_books(/index.:format)' => 'public/node/books#index'
  end
end
