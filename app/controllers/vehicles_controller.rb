class VehiclesController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @brand = params[:brand].to_s.strip
    @year = params[:year].to_s.strip
    @tariff = params[:tariff].to_s.strip
    @vehicles = Vehicle.indexable.ordered
                       .search(@q)
                       .by_brand(@brand)
                       .by_year(@year)
                       .by_tariff(@tariff)
    @brands = Vehicle.brand_options
    @tariffs = Vehicle.tariff_options
    @page = Page.find_by(slug: "avtomobili-dlya-taksi", published: true)
    set_seo_meta(
      @page,
      title: "Список автомобилей для работы в Яндекс Такси — проверка машины",
      description: "Какие автомобили подходят для работы в Яндекс Такси? Каталог моделей Таксопарк Космо с проверкой по источнику. Без выдуманных допусков.",
      h1: "Какие автомобили подходят для работы в Яндекс Такси"
    )
  end

  def show
    @vehicle = Vehicle.indexable.find_by!(slug: params[:slug])
    @cities = City.indexable.ordered
    @faqs = Faq.published.for_scope("avtomobili-dlya-taksi").ordered.limit(8)
    set_seo_meta(
      title: @vehicle.seo_title.presence || "#{@vehicle.display_name} для Яндекс Такси — требования",
      description: @vehicle.seo_description.presence || "Проверьте, подходит ли #{@vehicle.display_name} для работы в Яндекс Такси. Данные с проверкой по источнику.",
      h1: @vehicle.h1.presence || "#{@vehicle.display_name} для Яндекс Такси",
      robots: @vehicle.robots_meta.presence || "index,follow"
    )
  end
end
