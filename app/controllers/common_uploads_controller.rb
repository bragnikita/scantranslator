class CommonUploadsController < ApplicationController

  def common_image

    if params[:object_id].blank?
      image = Common::Image.new
    else
      image = Common::Image.find(params[:object_id])
    end
    image.file = params[:file]
    image.save!

    render json: {
        result: 0,
        object_id: image.id,
        object_url: image.file.url
    }
  end

end