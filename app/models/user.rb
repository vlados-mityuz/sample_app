class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_blank: true

  #returns digest for string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Return random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers user in db to use in regular sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if specified token equals digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends an email with activation link
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Installs attributes for password reset
  def create_reeset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends an email with link to the form for new password
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if the time for password reset is expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines feed
  def feed 
    Micropost.where("user_id = ?", id)
  end

  private

    # Downcases email
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns activation token and its digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
