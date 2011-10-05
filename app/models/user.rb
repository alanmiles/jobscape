# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  account            :integer         default(1)
#  terms              :boolean         default(FALSE)
#  latitude           :float
#  longitude          :float
#  address            :string(255)
#  city               :string(255)
#  country            :string(255)



require 'digest'
class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation, :account, :terms, :latitude, :longitude, :address

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  ACCOUNT_TYPES = [
    ["Individual", 1],
    ["Jobseeker", 2],
    ["Business", 3],
    ["Invitee", 4]
  ]
  
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end
  
  has_many :employees, :dependent => :destroy
  has_many :businesses, :through => :employees
  
  validates :name, 	:presence 	=> true,
  			:length		=> { :maximum => 50 }
  validates :email,	:presence	=> true,
  			:format 	=> { :with => email_regex },
  			:uniqueness 	=> { :case_sensitive => false }
  validates :account,	:presence 	=> true,
  			:numericality	=> { :integer => true } 
  			
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, 	:presence    	=> true,
                      	:confirmation 	=> true,
                       	:length       	=> { :within => 6..40 }
                       	
  before_save :encrypt_password
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode, :if => :address_changed?

  def belongs_to_business?
    businesses.count > 0
  end
  
  def single_business?
    if belongs_to_business?
      businesses.count == 1
    end
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_attribute_submissions?
    total = Quality.find_all_by_created_by(self.id).count
    return true if total > 0 
  end
  
  def account_type
    if account == 2
      return "Jobseeker"
    elsif account == 3
      return "Business"
    elsif account == 4
      return "Invitee"
    else
      return "Individual"
    end
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

