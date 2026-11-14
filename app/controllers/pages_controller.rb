class PagesController < ApplicationController
  def show
    @page = Page.published.find_by!(slug: params[:slug])
    @cities = City.indexable.ordered
    @faqs = Faq.published.for_scope(@page.slug).ordered.limit(12)
    set_seo_meta(@page)
  end
end
