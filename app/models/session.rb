require 'digest'
class Session < ActiveRecord::Base
  def valid_session?(secret_token)
    @session = Session.find_by(:secret_token => secret_token)
    @session.agent_token == generate_agent_session
  end

  def generate_agent_session(secret_token,ip,user_agent)
    Digest::SHA256.base64digest(secret_token + ip.to_s + user_agent)
  end
end
