module ApplicationHelper
  def page_title
    seo_meta[:title].presence || site_name
  end

  def meta_description
    seo_meta[:description]
  end

  def canonical_url
    seo_meta[:canonical]
  end

  def robots_meta_content
    seo_meta[:robots] || "index,follow"
  end

  def register_path_for(city: nil, courier_type: nil)
    self_register_href(city: city, courier_type: courier_type)
  end

  def registration_available?(city: nil, courier_type: nil)
    self_register_href(city: city, courier_type: courier_type).present?
  end

  def self_register_link_options
    opts = {
      class: "btn btn-primary",
      data: {
        controller: "analytics",
        analytics_event_value: "self_register_click",
        action: "click->analytics#track"
      }
    }
    if self_register_external?
      opts[:target] = "_blank"
      opts[:rel] = "noopener noreferrer"
    end
    opts
  end

  def og_image_url_for(record = nil)
    if record.respond_to?(:og_image) && record.og_image.attached?
      url_for(record.og_image)
    end
  end

  def sanitize_content(html)
    sanitize(html.to_s, tags: %w[p br strong em ul ol li a h2 h3 h4], attributes: %w[href rel target])
  end

  def lead_status_options
    Lead.statuses.keys.map { |s| [ I18n.t("leads.statuses.#{s}", default: s), s ] }
  end
end
