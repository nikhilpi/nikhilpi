class User < ActiveRecord::Base
	#attr_accessor :first_name, :last_name, :email
	validates :first_name, presence: true, length: { maximum: 50 }
	validates :last_name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	before_create :create_remember_token
	before_save { self.email = email.downcase }
	has_secure_password
	validates :password, length: { minimum: 6 }
	has_many :projects, dependent: :destroy

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	private

   		def create_remember_token
      		self.remember_token = User.digest(User.new_remember_token)
    	end
end
