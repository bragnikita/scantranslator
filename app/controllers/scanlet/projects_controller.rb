class Scanlet::ProjectsController < ApplicationController

  layout 'application'

  def index
    @projects = Scanlet::Project.all
  end

  def show
    @project = Scanlet::Project.find(params[:id])
  end

end