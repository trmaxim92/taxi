class FaqsController < ApplicationController
  CATEGORIES = [
    [ "Подключение", "podklyuchenie" ],
    [ "Тарифы и комиссии", "tarify" ],
    [ "Документы", "dokumenty" ],
    [ "Автомобиль", "avtomobil" ],
    [ "Выплаты", "vyplaty" ],
    [ "Яндекс Про", "yandex-pro" ],
    [ "Работа с парком", "park" ],
    [ "Частые вопросы", "home" ]
  ].freeze

  def index
    @page = Page.find_by(slug: "faq", published: true)
    @faq_groups = CATEGORIES.filter_map do |title, scope|
      faqs = Faq.published.for_scope(scope).ordered
      next if faqs.blank?

      { title: title, scope: scope, faqs: faqs }
    end

    if @faq_groups.blank?
      home_faqs = Faq.published.for_scope("home").ordered
      @faq_groups = [ { title: "Частые вопросы", scope: "home", faqs: home_faqs } ] if home_faqs.any?
    end

    @faqs = @faq_groups.flat_map { |group| group[:faqs] }
    set_seo_meta(
      @page,
      title: @page&.seo_title.presence || "Вопросы и ответы — Таксопарк Космо",
      description: @page&.seo_description.presence || "Ответы на вопросы о подключении к Яндекс Такси через Таксопарк Космо: комиссия, документы, автомобиль и работа через парк.",
      h1: @page&.h1.presence || "Вопросы и ответы"
    )
  end
end