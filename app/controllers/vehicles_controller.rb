class VehiclesController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @vehicles = Vehicle.indexable.ordered.search(@q)
    @page = Page.find_by(slug: "avtomobili-dlya-taksi", published: true)
    set_seo_meta(
      @page,
      title: "Список автомобилей для работы в Яндекс Такси — проверка машины",
      description: "Какие автомобили подходят для работы в Яндекс Такси? Изучите список моделей, требования к году выпуска, комплектации и тарифным категориям.",
      h1: "Какие автомобили подходят для работы в Яндекс Такси"
    )
  end

  def show
    @vehicle = Vehicle.indexable.find_by!(slug: params[:slug])
    @cities = City.indexable.ordered
    @faqs = Faq.published.for_scope("avtomobili-dlya-taksi").or(Faq.published.for_scope("home")).ordered.limit(8)
    set_seo_meta(
      title: @vehicle.seo_title.presence || "#{@vehicle.display_name} для Яндекс Такси — требования",
      description: @vehicle.seo_description.presence || "Проверьте, подходит ли #{@vehicle.display_name} для работы в Яндекс Такси. Данные с проверкой по источнику.",
      h1: @vehicle.h1.presence || "#{@vehicle.display_name} для Яндекс Такси"
    )
  end
end
