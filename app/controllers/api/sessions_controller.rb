class Api::SessionsController < ApplicationController

  after_filter :set_csrf_headers, only: [:create, :destroy]

  def create
    # Session.create(user_id: params["user_id"],session_token: params["session_token"])
    session_obj = nil
    if params[:session_token]
      session_obj  = Session.find_by(session_token: session_token)
      if session_obj
        @user = User.find(session_obj.user_id)
      end
    elsif params[:email] && params[:password]
      @user = User.find_by_credentials(params[:email],params[:password])
    else
      @user = nil
    end
    if @user
      # @session_token = generate_token(@user.email)
      # login(@user.id)
      @session_token = params[:session_token]
      render 'api/users/show'
    else
      if session_obj || params[:session_token]
        render(
          json: {"error"=>"Invalid Session Token"},status: 401
        )
      else
        render(
          json: {"error"=>"Invalid username/password combination"},status: 401
        )
      end
    end
  end

  def destroy
    @user = current_user
    logout
    render 'api/users/show'
  rescue
    render(
      json: {"error"=>"Cannot find user"},status: 401
    )
  end

  protected
  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end

# session_token = BCrypt(current_time + email + SecureRandom)

# save this to DB
# token = session_token + HTTP_USER_AGENT + HTTP_X_FORWARDED_FOR
