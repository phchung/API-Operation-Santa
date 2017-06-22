class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_filter :add_allow_credentials_headers
  helper_method :current_user, :logged_in?

  def login(user_id)
    # user_agent = request.user_agent
    # x_forwarded_For = request.remote_ip
    # session_token = BCrypt::Password.create(user_agent+x_forwarded_For+token)
    st = session_token
    Session.create(user_id: user_id, session_token: st)
  end

  def current_user
    user_id = Session.find_by(session_token: session_token).user_id
    @current_user ||= User.find(user_id)
  end

  def session_token
    st = params[:session_token] ? params[:session_token] : session[:session_token]
    digest_session_token = request.user_agent + request.remote_ip + st
    Digest::SHA1.hexdigest(digest_session_token)
  end

  def logout
    Session.where(session_token: session_token).delete
    session[:session_token] = nil
    @current_user = nil
  end

  def generate_token(email)
    current_time = Time.now
    secure_random = SecureRandom.urlsafe_base64(16)
    email = email
    token_str = current_time.to_s + secure_random + email.to_s
    session[:session_token] = Digest::SHA1.hexdigest(token_str)
    session[:session_token]
  end


  def require_logged_in
    render json: {base: ['invalid credentials']}, status: 401 if !current_user
  end

  def logged_in?
    !!current_user
  end

  def add_allow_credentials_headers
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5
    #
    # Because we want our front-end to send cookies to allow the API to be authenticated
    # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so
    # the browser will not reject the response
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'
  end
end
