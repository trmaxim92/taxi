class CitiesController < ApplicationController
  def index
    @cities = City.indexable.ordered
    @cities_by_region = @cities.group_by { |city| city.region.to_s.strip }
    @page = Page.find_by(page_type: "cities_index", published: true)
    set_seo_meta(
      @page,
      title: @page&.seo_title.presence || "Города подключения водителей Яндекс Такси",
      description: @page&.seo_description.presence || "Список городов, где доступно подключение водителей к Яндекс Такси на собственном автомобиле.",
      h1: @page&.h1.presence || "Работа в Яндекс Такси в городах России"
    )
  end

  def show
    @city = City.published.find_by!(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless @city.indexable?

    @referral_link = current_referral_link(city: @city)
    @faqs = Array(@city.faq_items)
    @cities = City.indexable.ordered
    set_seo_meta(
      @city,
      title: @city.seo_title.presence || "Работа в Яндекс Такси #{@city.name_prepositional} — подключение водителей",
      description: @city.seo_description.presence || "Подключение водителей Яндекс Такси #{@city.name_prepositional} на собственном автомобиле. Оставьте заявку онлайн.",
      h1: @city.h1.presence || "Работа в Яндекс Такси #{@city.name_prepositional}",
      robots: @city.indexable? ? (@city.robots_meta.presence || "index,follow") : "noindex,follow"
    )
  end
end
