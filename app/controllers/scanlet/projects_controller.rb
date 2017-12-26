class Scanlet::ProjectsController < ApplicationController

  layout 'application'

  def index
    @projects = Scanlet::Project.all
  end

  def show
    @project = Scanlet::Project.find(params[:id])
    @editable = false
  end

  def new
    @project = Scanlet::Project.new
    @editable = true
    render 'show'
  end

  def edit
    @project = Scanlet::Project.find(params[:id])
    @editable = true
    render 'show'
  end

  def create
    @project = Scanlet::Project.new

    @project.name = params[:title]
    @project.description = params[:description]

    if params[:cover_id].present?
      cover_id = params[:cover_id]
      @project.create_cover({target_id: cover_id})
    end
    @project.save!

    if request.xhr?
      render json: {
          result: 0,
          object_id: @project.id,
          goto: scanlet_project_path(@project.id)
      }
    else
      redirect_to action: :show, id: @project.id
    end
  end

  def update

    @project = Scanlet::Project.find(params[:id])

    @project.name = params[:title]
    @project.description = params[:description]


    old_cover = nil
    if params[:cover_id].present?
      old_cover = @project.cover
      cover_id = params[:cover_id]
      @project.create_cover({target_id: cover_id})
    end
    @project.save!
    if old_cover.present?
      old_cover.destroy!
    end


    if request.xhr?
      render json: {
          result: 0
      }
    else
      render action: :show, id: @project.id
    end

  end

end