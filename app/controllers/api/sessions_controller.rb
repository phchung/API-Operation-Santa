class Api::SessionsController < ApplicationController

  after_filter :set_csrf_headers, only: [:create, :destroy]

  def create
    if params[:session_token]
      @user = User.find_by(session_token: params[:session_token])
    else
      @user = User.find_by_credentials(
        params[:username],
        params[:password]
      )
    end
    if @user
      login(@user)
      @session = true
      render 'api/users/show'
    else
      render(
        json: {"error"=>"Invalid username/password combination"},status: 401
      )
    end
  end

  def destroy
    @user = current_user
    if @user
      logout
      render 'api/users/show'
    else
      render(
        json: {"error"=>"Cannot find user"},status: 401
      )
    end
  end

  protected
  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end
