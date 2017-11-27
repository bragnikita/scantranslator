class ApplicationController < ActionController::Base

  layout 'application'
  helper_method :signed_up?

  def index
    render 'index'
  end

  def signed_up?
    @user.present? || !session[:login].blank?
  end

  protected


  def check_session!
    if Rails.env.test?
      authenticate! 'nikita' and return
    end

    login = session['login']
    if login.blank?
      redirect_to '/sign_up' and return
    end

    authenticate! login

  end


  def sign_up!(login, password)
    if ENV['ADMIN_LOGIN'] == login && ENV['ADMIN_PASSWORD'] == password
      session[:login] = login
      true
    else
      false
    end
  end

  def logout!
    session[:login] = nil
  end

  private


  def authenticate!(login)
    @user = Users::User.new(login)
  end

end

module Users
  class User
    attr_accessor :login

    def initialize(login)
      self.login = login
    end

  end
end