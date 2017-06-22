class User < ActiveRecord::Base

validates :username, :session_token, :password_digest,:first_name,:last_name, presence: true
validates :password, length: {minimum: 6, allow_nil: true}
validates :username, uniqueness: true

attr_reader :password
after_initialize :ensure_session_token

has_one :family_data, foreign_key: "user_id", class_name: "Family"
has_many :family_match, foreign_key: "donor_id", class_name: "Relationship"
has_many :donors_match, foreign_key: "family_id", class_name: "Relationship"


 def password=(password)
   @password = password
   self.password_digest = BCrypt::Password.create(password)
 end

 def is_password?(password)
   BCrypt::Password.new(self.password_digest).is_password?(password)
 end

 def self.find_by_credentials(username,password)
   user = User.find_by(username: username)
   return nil unless user && user.is_password?(password)
   user
 end
 # time when created
 # email
 # sha256

 def restore_token!
   self.session_token = SecureRandom.urlsafe_base64(16)
   self.save!
   self.session_token
 end

 def generate_token
   current_time = Time.now
   secure_random = SecureRandom.urlsafe_base64(16)
   email = self.email
   token_str = current_time.to_s + secure_random + email.to_s
   session[:session_token] = BCrypt::Password.create(token_str)
   session[:session_token]
 end

 def matches
   Relationship.where("donor_id = ? OR family_id = ?", self.id, self.id)
 end

 private

 def ensure_session_token
   self.session_token ||= SecureRandom.urlsafe_base64(16)
 end

end
