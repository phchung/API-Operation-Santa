class Api::SessionsController < ApplicationController

  after_filter :set_csrf_headers, only: [:create, :destroy]

  def create
    # Session.create(user_id: params["user_id"],session_token: params["session_token"])
    if params[:session_token]
      user_id  = Session.find_by(session_token: session_tokens).first.id
      @user = User.find(user_id)
    else
      @user = User.find_by_credentials(
        params[:username],
        params[:password]
      )
      @session_token = generate_token(@user.email)
      login(@user.id) if @user
    end
    if @user
      @session = true
      render 'api/users/show'
    else
      session[:session_token] = nil
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

# session_token = BCrypt(current_time + email + SecureRandom)

# save this to DB
# token = session_token + HTTP_USER_AGENT + HTTP_X_FORWARDED_FOR
