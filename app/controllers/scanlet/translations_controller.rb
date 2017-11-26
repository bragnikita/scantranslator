class Scanlet::TranslationsController < ActionController::Base

  layout 'application'

  def show
    @translation = Scanlet::Translation.find(params[:id])
  end

  def new
    unless params[:group].blank?
      @group = Scanlet::Group.find(params[:group])
    end
    @translation = Scanlet::Translation.new(group: @group)
  end

  def create
    scan = Scanlet::Scan.new
    scan.image = params[:scanlet_translation][:image]
    scan.save!
    translation = Scanlet::Translation.new(translation_params)
    translation.scan = scan
    unless params[:group].blank?
      translation.group = Scanlet::Group.find(params[:group])
    end
    result = translation.save!
    if result
      redirect_to scanlet_translation_path(translation)
    else
      unless params[:group].blank?
        @group = Scanlet::Translation.find(params[:scanlet_translation][:group])
      end
      @translation = translation
      render "new", response_code: 402
    end
  end

  private

  def translation_params
    params.require(:scanlet_translation).permit(:translation, :group_id)
  end

end