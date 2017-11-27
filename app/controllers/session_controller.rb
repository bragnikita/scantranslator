class SessionController < ApplicationController

  layout 'application'

  def show
    redirect_to '/' and return if signed_up?
    render '/sign_up'
  end

  def signup
    login = params[:login]
    password = params[:password]
    if sign_up! login, password
      redirect_to '/'
    else
      flash[:error] = 'Login-password pair seems wrong'
      render '/sign_up'
    end
  end

  def logout
    logout!
    redirect_to '/'
  end

end