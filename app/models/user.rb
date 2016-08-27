class User < ActiveRecord::Base
  #attr_accessible :email, :password, :password_confirmation
  attr_accessor :password
  before_save :encrypt_password
  #before_create {generate_token(:auth_token)}
  # validates_presence_of :email
  # validates_uniqueness_of :email
  validates :email, presence: true, uniqueness: true
  

  # validates_confirmation_of :password
 
  # has_secure_password
  # validates_presence_of :password, :on => :create
  # validates :password_confirmation, presence: true
  validates :password, presence: true, confirmation: true, on: :create
  before_create { generate_token(:auth_token) }


  # def self.authenticate(email, password)
  #   find_by(email: email, password: BCrypt::Engine.hash_secret(password, user.password_salt))
  #   # if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  #   #   user
  #   # else
  #   #   nil
  #   # end
  # end

    def self.authenticate(email, password)
      user = find_by_email(email)
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      else
        nil
      end
    end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def generate_token(column)
    #begin
    self[column] = SecureRandom.urlsafe_base64
  #end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    update_attribute(:password_reset_sent_at, Time.now)
    # self.password_reset_sent_at = Time.zone.now #+ 30
    save!
    UserMailer.password_reset(self).deliver
  end
end