class HomeController < ApplicationController
  def index
    @cities = City.indexable.ordered
    @featured_cities = City.indexable.featured.ordered.presence || @cities.limit(8)
    @faqs = Faq.published.for_scope("home").ordered
    @page = Page.find_by(page_type: "home", published: true)
    @selected_city_referral = selected_city ? current_referral_link(city: selected_city) : current_referral_link
    set_seo_meta(
      @page,
      title: "Работа в Яндекс Такси на своем автомобиле — подключение водителей",
      description: "Хотите работать водителем в Яндекс Такси? Подключайтесь через таксопарк Космо, работайте на собственном автомобиле, получайте поддержку и удобный доступ к заказам. Оставьте заявку онлайн.",
      h1: "Работа в Яндекс Такси на собственном автомобиле",
      og_image: "#{request.base_url}/images/hero-taxi.jpg"
    )
  end
end
