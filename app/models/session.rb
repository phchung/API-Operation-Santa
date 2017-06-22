require 'digest'

class Session < ActiveRecord::Base
  after_initialize :sessions_capacity
  after_initialize :ensure_expiration

  def sessions_capacity
    session_lists = Session.where(user_id: self.user_id).order('created_at desc')
    session_lists.first.delete if session_lists.length > 5
  end

  def ensure_expiration
    self.expiration = Date.today + 1.years
  end

  def valid_session?(secret_token)
    @session = Session.find_by(:secret_token => secret_token)
    @session.agent_token == generate_agent_session
  end

  def generate_agent_session(secret_token,ip,user_agent)
    Digest::SHA256.base64digest(secret_token + ip.to_s + user_agent)
  end
end
