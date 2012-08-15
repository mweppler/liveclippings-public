
# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  first_name             :string(25)
#  last_name              :string(50)
#  email                  :string(100)     default(""), not null
#  username               :string(25)      not null
#  hashed_password        :string(40)      not null
#  salt                   :string(40)      not null
#  created_at             :datetime
#  updated_at             :datetime
#  user_hash              :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  api_token              :string(40)
#  api_token_created_at   :datetime
#

require 'digest/sha1'

class User < ActiveRecord::Base

  has_many :clippings
  has_many :followings

  attr_accessor :password, :api_answer
  attr_protected :hashed_password, :salt

  after_save  :clear_password
  before_save :create_hashed_password, :generate_api_token

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  scope :named, lambda { |first,last| where(:first_name => first, :last_name => last) }
  scope :sorted, order("users.last_name ASC, users.first_name ASC")

  validates :email,      :format => EMAIL_REGEX, :length => { :maximum => 100 }, :presence => true, :uniqueness => true
  validates :first_name, :length => { :within => 1..25 }, :presence => true
  validates :last_name,  :length => { :within => 1..50 }, :presence => true
  validates :password,   :confirmation => true, :length => { :within => 8..25 }, :presence => true,    :on => :create
  validates :password,   :confirmation => true, :length => { :within => 8..25 }, :allow_blank => true, :on => :update
  validates :username,   :length => { :within => 4..25 }, :uniqueness => true

  def self.authenticate(username="", password="")
    user = User.find_by_username(username)
    if user && user.password_match?(password)
      return user
    else
      return false
    end
  end

  def generate_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
    end while self.class.exists?(password_reset_token: password_reset_token)
  end

  def generate_api_token
    return if api_answer === 'no'
    begin
      self.api_token = Digest::SHA1.hexdigest("Use your own method to generate this.")
      self.api_token_created_at = Time.zone.now
    end while self.class.exists?(api_token: api_token)
  end

  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Use your own method to generate this.")
  end

  def self.make_salt(username="")
    Digest::SHA1.hexdigest("Use your own method to generate this.")
  end

  def name
    "#{first_name} #{last_name}"
  end

  def password_match?(password="")
    hashed_password == User.hash_with_salt(password, salt)
  end

  def send_password_reset
    generate_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.forgot_password(self).deliver
  end

  private
  
  def create_hashed_password
    # Whenever :password has a value hashing is needed
    unless password.blank?
      # always user "self" when assigning values
      self.salt = User.make_salt(username) if salt.blank?
      self.hashed_password = User.hash_with_salt(password, salt)
    end
  end

  def clear_password
    # for security and b/c hashing is not needed
    self.password = nil
  end

end
