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
        :controller => 'admin/entries' do
          collection do
            post :import
            get  :import
          end
        end
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

    get 'node_dbs(/index)'            => 'public/node/dbs#index'
    get 'node_dbs/:id(/index)'        => 'public/node/dbs#show'
    get 'node_dbs/:db_id/map'         => 'public/node/dbs#map'
    get 'node_dbs/:db_id/address'     => 'public/node/dbs#address'
    get 'node_dbs/:db_id/search'      => 'public/node/dbs#result'
    get 'node_dbs/:db_id/entry/:name' => 'public/node/dbs#entry'
  end

end
