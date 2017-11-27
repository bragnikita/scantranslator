class ExtImagesController < ApplicationController
  include ImagesHelper

  helper_method :original_url

  before_action :check_session!
  before_action :set_image, only: [:destroy, :show]


  def index
    @images = ExtImage.all.order(created_at: :desc)
    @image = ExtImage.new
  end

  def create
    folder_id = params['folder_id']
    folder = folder_id.blank? ? get_default_folder : Folder.find(folder_id)
    @image = folder.images.create(uploaded_image_params)
    if @image.valid?
      url = original_url(@image.image)
      respond_to do |f|
        f.json {render json: {result: 0, original_url: url}}
        f.html {redirect_to :action => :index}
      end
    else
      respond_to do |f|
        f.json {render status: :unprocessable_entity, json: {result: 1, errors: @image.errors.messages}}
        f.html {
          flash[:errors] = @image.errors.messages
          redirect_to :action => :index
        }
      end
    end
  end

  def destroy
    render status: 404 if @image.nil?
    @image.to_trash
    respond_to do |f|
      f.json {render json: {result: 0, original_url: @image.image.url}}
      f.html {redirect_to :action => :index}
    end

  end

  def destroy_and_unpublish_image
    render status: 404 if @image.nil?
    @image.destroy!
    respond_to do |f|
      f.json {render json: {result: 0}}
      f.html {redirect_to action: :index}
    end
  end

  def show
    render status: 404 if @image.nil?
    render json: {
      result: 0,
      original_url: original_url(@image.image),
      thumb: original_url(@image.image.thumb)
    }
  end

  private

  def uploaded_image_params
    params.require(:ext_image).permit(:image)
  end

  def set_image
    @image = ExtImage.find(params['id'])
  end


  def get_default_folder
    Folders.find_by(path: '/common')
  end

end