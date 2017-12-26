class Scanlet::TranslationsController < ApplicationController

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
    group_id = params[:group_id]
    image_ids = []
    unless params[:image_id].nil?
      image_ids << params[:image_id]
    end
    unless params[:image_ids].nil?
      image_ids = params[:image_ids]
    end

    last = Scanlet::Group.find(group_id).translations.order(:index => :asc).last
    if last.nil?
      last_index = 0
    else
      last_index = last.index
    end
    ops = []
    image_ids.each_with_index do |id, index|
      op = Scanlet::TranslationOperations::AddNewTranslation.new(group_id, id)
      op.index = last_index + index + 1
      op.call
      ops << op
    end

    if request.xhr?
      render json: {
          result: 0,
          object_id: ops.map {|op| op.result.id }
      }
    end
  end


  private

  def translation_params
    params.require(:scanlet_translation).permit(:translation, :group_id)
  end

end