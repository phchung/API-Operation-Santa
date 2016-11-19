class Api::SessionsController < ApplicationController

  after_filter :set_csrf_headers, only: [:create, :destroy]

  def create
    @user = User.find_by_credentials(
      params[:username],
      params[:password]
    )
    if @user
      login(@user)
      render 'api/users/show'
    else
      render(
        json: {
          base: ["Invalid username/password combination"]
        },
        status: 401
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
        json: {
          base: ['Invalid username/password combination']
        },
        status: 401
      )
    end
  end

  protected
  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end
