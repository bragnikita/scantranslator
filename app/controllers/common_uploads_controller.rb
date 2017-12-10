class CommonUploadsController < ApplicationController

  def common_image

    unless params[:object_id].blank?
      image = CommonImage.find(params[:object_id])
    else
      image = CommonImage.new
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