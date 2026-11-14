class SitemapsController < ApplicationController
  STATIC_PATHS = %w[
    /
    /o-kompanii/
    /podklyuchenie/
    /trebovaniya/
    /dokumenty/
    /tarify/
    /rabota-na-svoem-avto/
    /usloviya-raboty/
    /yandex-pro/
    /rabota-cherez-park/
    /goroda/
    /faq/
    /kontakty/
    /privacy/
    /agreement/
  ].freeze

  def index
    @sitemaps = [
      { loc: sitemap_pages_url(format: :xml), lastmod: Page.published.maximum(:updated_at) },
      { loc: sitemap_cities_url(format: :xml), lastmod: City.indexable.maximum(:updated_at) }
    ]
    render formats: :xml
  end

  SKIP_PAGE_TYPES = %w[home cities_index reviews blog_index blog].freeze
  SKIP_PAGE_SLUGS = %w[
    o-kompanii podklyuchenie trebovaniya dokumenty faq privacy agreement
    kak-ustroitsya usloviya-raboty rabota-na-svoem-avto trebovaniya-k-voditelyam
    tarify yandex-pro avtomobili-dlya-taksi rabota-cherez-park kontakty
    rabota-v-yandex-eda rabota-kurerom
  ].freeze

  def pages
    @entries = []
    seen = {}

    add_entry = lambda do |path, lastmod|
      loc = "#{request.base_url}#{path}"
      return if seen[loc]

      seen[loc] = true
      @entries << { loc: loc, lastmod: lastmod }
    end

    STATIC_PATHS.each { |path| add_entry.call(path, Time.current) }
    Page.published.where.not(robots_meta: [ "noindex,follow", "noindex,nofollow" ]).find_each do |page|
      next if SKIP_PAGE_TYPES.include?(page.page_type)
      next if SKIP_PAGE_SLUGS.include?(page.slug)

      add_entry.call("/#{page.slug}/", page.updated_at)
    end
    render template: "sitemaps/urlset", formats: :xml
  end

  def cities
    @entries = City.indexable.select(&:indexable?).map do |city|
      { loc: "#{request.base_url}/goroda/#{city.slug}/", lastmod: city.content_updated_at || city.updated_at }
    end
    render template: "sitemaps/urlset", formats: :xml
  end
end
