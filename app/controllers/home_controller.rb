class HomeController < ApplicationController
  def index
    @cities = City.indexable.ordered
    @featured_cities = City.indexable.featured.ordered.presence || @cities.limit(8)
    @faqs = Faq.published.for_scope("home").ordered.limit(12)
    @tariffs = Tariff.active.ordered
    @page = Page.find_by(page_type: "home", published: true)
    @selected_city_referral = selected_city ? current_referral_link(city: selected_city) : current_referral_link

    park_fee = SiteSetting.get("park_commission_percent", "2")
    withdraw_fee = SiteSetting.get("withdrawal_fee_percent", "1")

    set_seo_meta(
      @page,
      title: "Подключение к Яндекс Такси на собственном автомобиле — Таксопарк Космо",
      description: "Работайте с заказами Яндекс Такси через Таксопарк Космо. Комиссия парка #{park_fee}% с заказа и банковская комиссия #{withdraw_fee}% при выводе средств. Оставьте заявку онлайн.",
      h1: "Подключение к Яндекс Такси на собственном автомобиле",
      og_image: "#{request.base_url}/images/hero-taxi.jpg"
    )
  end
end
