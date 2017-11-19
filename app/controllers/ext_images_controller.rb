class ExtImagesController < ActionController::Base

  layout 'application'
  helper_method :original_url
  before_action :set_image, only: [:destroy, :show]

  def index
    @images = ExtImage.all.order(created_at: :desc)
    @image = ExtImage.new
  end

  def create
    @image = ExtImage.new(uploaded_image_params)
    @image.save!
    url = original_url(@image.image)
    respond_to do |f|
      f.json { render json: {result: 0, original_url: url}}
      f.html { redirect_to :action => :index }
    end
  end

  def destroy
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
    params.require(:ext_image).permit(:image, :folder)
  end

  def set_image
    @image = ExtImage.find(params['id'])
  end

  def original_url(image)
    url = image.url
    if /\A\// =~ url
      url = request.base_url + url
    end
    url
  end

end