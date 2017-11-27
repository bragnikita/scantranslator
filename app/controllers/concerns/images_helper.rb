module ImagesHelper
  extend ActiveSupport::Concern

  def original_url(image)
    url = image.url
    if /\A\// =~ url
      url = request.base_url + url
    end
    url
  end
end