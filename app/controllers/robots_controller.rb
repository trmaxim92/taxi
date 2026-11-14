class RobotsController < ApplicationController
  def show
    host = ENV.fetch("APP_HOST", request.host)
    base = "#{request.scheme}://#{host}"
    render plain: <<~ROBOTS
      User-agent: *
      Allow: /
      Disallow: /admin/
      Disallow: /go/
      Disallow: /leads
      Disallow: /users/

      Sitemap: #{base}/sitemap.xml
    ROBOTS
  end
end
