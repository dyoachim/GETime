class Employee < ActiveRecord::Base
	attr_accessible :name, :username, :password, :password_confirmation, :active_employee
	has_many :timesheets, dependent: :destroy
	has_secure_password

	before_save { |employee| employee.username = username.downcase }
	before_save :create_remember_token

	validates :name, presence: true, length: {maximum: 40}
	validates :username, presence: true, length: {maximum:40}, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum:6}, :if => :should_validate_password?
	validates :password_confirmation, presence: true, :if => :should_validate_password?


	def destroy
		self.active_employee = false
		self.save!
	end

    def should_validate_password?
		password || new_record?
    end

    private

	    def create_remember_token
	      self.remember_token = SecureRandom.urlsafe_base64
	    end
end
