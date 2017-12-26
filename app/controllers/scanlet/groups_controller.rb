class Scanlet::GroupsController < ApplicationController

  layout 'application'

  def show
    @presenter = Scanlet::GroupPresenter.new(:view, Scanlet::Group.find(params[:id]))
    render "scanlet/groups/show"
  end

  def edit
    @presenter = Scanlet::GroupPresenter.new(:edit, Scanlet::Group.find(params[:id]), params)
    if request.xhr?
      render @presenter.respond_json
    else
      render "scanlet/groups/edit"
    end
  end

  def new
    @presenter = Scanlet::GroupPresenter.new(:new, Scanlet::Group.new, params)
    render "scanlet/groups/edit"
  end

  def create
    group = Scanlet::Group.create!(group_params)
    if request.xhr?
      @presenter = Scanlet::GroupPresenter.new(:view, group)
      render @presenter.respond_json
    else
      if group.valid?
        redirect_to action: "show", id: group.id
      else
        @presenter = Scanlet::GroupPresenter.new(:new, group, params)
        render "scanlet/groups/edit"
      end
    end
  end

  def update
    group = Scanlet::Group.find(params[:id])
    group.update_attributes(group_params)
    if request.xhr?
      @presenter = Scanlet::GroupPresenter.new(:view, group)
      render @presenter.respond_json
    else
      if group.valid?
        redirect_to action: "show", id: group.id
      else
        @presenter = Scanlet::GroupPresenter.new(:edit, group, params)
        render "scanlet/groups/edit"
      end
    end
  end

  def translations
    @translations = Scanlet::Group.find(params[:id]).translations.order(:index => :asc)
    render :partial => "scanlet/groups/pages", locals: {translations: @translations}
  end

  def edit_translations

  end

  private

  def group_params
    params.require(:group).permit(:name, :index, :project_id)
  end

end