# attributes: username, email, password, password_confirmation

class User < ActiveRecord::Base
	has_secure_password

	has_many :sources
	has_many :comments
	has_many :votes
end
