Rails.application.routes.draw do
  devise_for :users, path: "users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "up" => "rails/health#show", as: :rails_health_check
  get "robots.txt", to: "robots#show", as: :robots
  get "sitemap.xml", to: "sitemaps#index", as: :sitemap, defaults: { format: :xml }
  get "sitemap-pages.xml", to: "sitemaps#pages", as: :sitemap_pages, defaults: { format: :xml }
  get "sitemap-cities.xml", to: "sitemaps#cities", as: :sitemap_cities, defaults: { format: :xml }
  get "sitemap-vehicles.xml", to: "sitemaps#vehicles", as: :sitemap_vehicles, defaults: { format: :xml }

  root "home#index"
  post "select_city", to: "city_selections#create", as: :select_city
  delete "select_city", to: "city_selections#destroy"

  get "kak-ustroitsya", to: "pages#show", defaults: { slug: "kak-ustroitsya" }, as: :kak_ustroitsya
  get "usloviya-raboty", to: "pages#show", defaults: { slug: "usloviya-raboty" }, as: :usloviya_raboty
  get "rabota-na-svoem-avto", to: "pages#show", defaults: { slug: "rabota-na-svoem-avto" }, as: :rabota_na_svoem_avto
  get "trebovaniya-k-voditelyam", to: "pages#show", defaults: { slug: "trebovaniya-k-voditelyam" }, as: :trebovaniya_k_voditelyam
  get "rabota-cherez-park", to: "pages#show", defaults: { slug: "rabota-cherez-park" }, as: :rabota_cherez_park
  get "kontakty", to: "pages#show", defaults: { slug: "kontakty" }, as: :kontakty

  get "avtomobili-dlya-taksi", to: "vehicles#index", as: :avtomobili_dlya_taksi
  get "avtomobili-dlya-taksi/:slug", to: "vehicles#show", as: :avtomobil

  # Legacy courier URLs → taxi home / info pages
  get "rabota-v-yandex-eda", to: redirect("/", status: 301)
  get "rabota-kurerom", to: redirect("/kak-ustroitsya/", status: 301)
  get "rabota-peshim-kurerom", to: redirect("/trebovaniya-k-voditelyam/", status: 301)
  get "rabota-velokurerom", to: redirect("/trebovaniya-k-voditelyam/", status: 301)
  get "rabota-avtokurerom", to: redirect("/rabota-na-svoem-avto/", status: 301)

  get "otzyvy", to: "reviews#index", as: :otzyvy
  get "blog", to: "blog#index", as: :blog

  get "goroda", to: "cities#index", as: :goroda
  get "goroda/:city_slug/:courier_type_slug",
      to: redirect(status: 301) { |params, _req| "/goroda/#{params[:city_slug]}/" }
  get "goroda/:slug", to: "cities#show", as: :gorod

  resources :leads, only: :create
  get "spasibo", to: "leads#thank_you", as: :thank_you
  get "go/register", to: "registrations#go", as: :go_register

  namespace :admin do
    root to: "dashboard#index"
    resources :pages, except: :show
    resources :vehicles, except: :show
    resources :cities, except: :show do
      member do
        post :apply_seo_template
      end
    end
    resources :city_courier_pages, except: :show do
      member do
        get :preview
        post :apply_seo_template
      end
    end
    resources :courier_types, except: :show
    resources :leads, only: %i[index show edit update]
    resources :referral_links
    resources :reviews, except: :show
    resources :faqs, except: :show
    resources :redirects, except: :show
    resources :seo_templates, except: :show
    resource :seo, only: :show, controller: "seo"
    resources :site_settings, only: %i[index edit update]
    resources :users, except: :show
  end
end
