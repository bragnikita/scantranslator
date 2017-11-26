class Scanlet::ProjectsController < ActionController::Base

  layout 'application'

  def index
    @projects = Scanlet::Project.all
  end

  def show
    @project = Scanlet::Project.find(params[:id])
  end

end