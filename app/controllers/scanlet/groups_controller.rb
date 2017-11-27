class Scanlet::GroupsController < ApplicationController

  layout 'application'

  def show
    @group = Scanlet::Group.find(params[:id])
  end

end