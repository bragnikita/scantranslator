class FoldersController < ApplicationController
  include ImagesHelper

  before_action :check_session!

  def index
    @folders = Folder.all.order(:name)
    p @folders.size
    respond_to do |format|
      format.json {render json: {result: 0, data: @folders.to_a.map {|f| {id: f.id, path: f.path, parent: f.parent&.id}}}}
      format.html {render 'index'}
    end
  end

  def show
    query = {}
    query['id'] = params['id'] if params['id'].present?
    path = request.query_parameters['path']
    query['path'] = path unless path.blank?
    if query.empty?
      @folders = Folder.where(parent: nil).order(:name)
    else
      current = Folder.where(query).first
      if current.present?
        @current = current
        @folders = current.children.order(:name)
        @files = current.images.order(created_at: :desc)
      else
      end
    end
    @files = @files || []
    respond_to do |format|
      format.json {
        if @folders.nil?
          render status: 404, json: {}
        else
          render json: {
            result: 0,
            folders: @folders.map {|f| {id: f.id, name: f.name, parent: f.parent&.id}},
            files: @files.map {|f| {
              id: f.id,
              url: f.image.url
            }}
          }
        end
      }
      format.html {
        if @folders.nil?
          render status: 404
        else
          render 'show'
        end
      }
    end
  end

  def create
    p = folder_params
    parent_id = p['parent']
    parent = parent_id.present? ? Folder.find(parent_id) : nil
    f = Folder.create(name: p['name'], parent: parent)
    if f.valid?
      respond_to do |format|
        format.json {render json: {result: 0, id: f.id, path: f.path, parent: f.parent.try(:id)}}
        format.html {
          if request.xhr?
            @folders = Folder.where(parent: f.parent.try(:id)).order(:name)
            render :partial => 'folders_list'
          else
            redirect_to action: :show, id: f.id
          end
        }
      end
    end
  end

  def update
    f = Folder.find(params[:id])
    render status: 404, plain: "Not found" if f.nil?
    res = f.update(params.permit('name'))
    if res
      respond_to do |format|
        format.json {render json: {result: 0}}
      end
    else
      respond_to do |format|
        format.json {render status: 400, json: {result: -1, errors: f.errors.messages[:name]}}
      end
    end
  end

  def destroy
    id = params['id']
    f = Folder.find(id)
    render status: 404, json: {} and return if f.nil?
    if f.children.empty?
      res = f.destroy
      render status: 200, json: {} and return if res
      render status: 402, plain: f.errors.messages
    else
      render status: 402, plain: 'Forbidden: the folder is not empty'
    end
  end

  def upload
    f = Folder.find(params['id'])
    render status: 404, json: {} and return if f.nil?
    @folder = f
    render 'folders/upload'
  end


  private

  def folder_params
    params.require(:name)
    params.permit(:name, :parent)
  end
end