class Scanlet::GroupsController < ActionController::Base

  layout 'application'

  def show
    @group = Scanlet::Group.find(params[:id])
  end

end