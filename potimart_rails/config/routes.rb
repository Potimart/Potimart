ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  map.connect 'lines_by_indicator/:name.:format', :controller => 'lines_by_indicator', :action => 'index'
  map.connect 'stop_area_geos_by_indicator/:name.:format', :controller => 'stop_area_geos_by_indicator', :action => 'show'

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

  #  map.resources :stop_area_geos do |stoparea_geo|
  #    stoparea_geo.resources :lines do |line|
  #      line.resources :routes do |route|
  #        route.resources :stop_areas
  #      end
  #    end
  #  end

  map.resources :lines do |line|
    line.resources :service_links
    line.resources :line_indicators
    line.resources :routes do |route|
      route.resources :stop_area_geos do |stop_area_geo|
        stop_area_geo.resources :stop_area_geo_indicators
      end
    end
  end

  map.resources :stop_area_geos do |stop_area_geo|
    stop_area_geo.resources :stop_area_geo_indicators
  end

  map.resources :insee_communes do |insee_commune|
    insee_commune.resources :insee_commune_indicators
  end

  map.resources :insee_iriss
  map.resources :stop_area_geo_indicator_names
  map.resources :line_indicator_names

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => :lines

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

end