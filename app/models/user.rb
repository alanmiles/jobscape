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
#



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
  has_one :portrait, :dependent => :destroy
  has_many :achievements, :dependent => :destroy
  has_many :characteristics, :dependent => :destroy
  has_many :favourites, :dependent => :destroy
  has_many :dislikes, :dependent => :destroy
  has_many :qualifications, :dependent => :destroy
  has_many :strengths, :dependent => :destroy
  has_many :limitations, :dependent => :destroy
  has_many :aims, :dependent => :destroy
  has_many :references, :dependent => :destroy
  has_many :previousjobs, :dependent => :destroy
  has_many :placements, :dependent => :destroy
  has_many :jobs, :through => :placements
  has_many :applications, :dependent => :destroy
  
  has_many :reviewed_sessions, :foreign_key => "reviewee_id", :class_name => "Review", :dependent => :destroy
  has_many :reviewees, :through => :reviewed_sessions
  has_many :reviewer_sessions, :foreign_key => "reviewer_id", :class_name => "Review"
  has_many :reviewers, :through => :reviewer_sessions
  
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
  after_save :create_portrait
  after_save :create_user_business
  before_destroy :remove_private_business

  def belongs_to_business?
    #businesses.count > 0
    businesses.where("businesses.name != ?", "Biz_#{self.id}").count > 0
  end
  
  def single_business?
    if belongs_to_business?
      businesses.where("businesses.name != ?", "Biz_#{self.id}").count == 1
    end
  end
   
  def private_business
    @business = Business.find_by_name("Biz_#{self.id}")
  end
  
  def has_private_business?
    businesses.where("businesses.name = ?", "Biz_#{self.id}").count == 1
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
  
  def count_achievements
    self.achievements.count
  end
  
  def has_achievements?
    count_achievements > 0
  end
  
  def max_achievements?
    count_achievements >= 3  
  end
  
  def count_characteristics
    self.characteristics.count
  end
  
  def has_characteristics?
    count_characteristics > 0
  end
  
  def max_characteristics?
    count_characteristics >= 5  
  end
  
  def count_favourites
    self.favourites.count
  end
  
  def has_favourites?
    count_favourites > 0
  end
  
  def max_favourites?
    count_favourites >= 5  
  end
  
  def count_dislikes
    self.dislikes.count
  end
  
  def has_dislikes?
    count_dislikes > 0
  end
  
  def max_dislikes?
    count_dislikes >= 5  
  end
  
  def count_qualifications
    self.qualifications.count
  end
  
  def has_qualifications?
    count_qualifications > 0
  end
  
  def max_qualifications?
    count_qualifications >= 3  
  end
  
  def count_strengths
    self.strengths.count
  end
  
  def has_strengths?
    count_strengths > 0
  end
  
  def max_strengths?
    count_strengths >= 5  
  end
  
  def count_limitations
    self.limitations.count
  end
  
  def has_limitations?
    count_limitations > 0
  end
  
  def max_limitations?
    count_limitations >= 3  
  end
  
  def count_aims
    self.aims.count
  end
  
  def has_aims?
    count_aims > 0
  end
  
  def max_aims?
    count_aims >= 3  
  end
  
  def count_references
    self.references.count
  end
  
  def has_references?
    count_references > 0
  end
  
  def max_references?
    count_references >= 3
  end
  
  def count_previousjobs
    self.previousjobs.count
  end
  
  def has_previousjobs?
    count_previousjobs > 0
  end
  
  def max_previousjobs?
    count_previousjobs >= 5
  end
  
  def has_public_portrait?
    @portrait = Portrait.where("user_id = ?", self.id).first
    @portrait.public == true
  end
  
  def account_type
    if self.admin? 
      return "Admin"
    else
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
  end
  
  def no_job?
    placements.count == 0
  end
  
  def outdated_reviews
    self.reviewed_sessions.where("reviews.completed = ? and created_at <?", false, Date.today - 14)
  end
  
  def has_outdated_reviews?
    cnt = self.outdated_reviews.count
    cnt > 0
  end
  
  def incomplete_review
    self.reviewed_sessions.where("reviews.completed = ? and created_at >=?", false, Date.today - 14).limit(1)
  end
  
  def has_incomplete_review?
    cnt = self.incomplete_review.count
    cnt > 0
  end
  
  def completed_reviews
    self.reviewed_sessions.where("reviews.completed = ?", true).order("reviews.completion_date DESC")
  end
  
  def has_completed_reviews?
    nmbr = self.completed_reviews.count
    nmbr > 0
  end
  
  def last_review
    self.reviewed_sessions.where("reviews.completed = ?", true).last
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def create_portrait
      @portrait = self.build_portrait
      @portrait.save
    end
    
    def create_user_business
      if self.account == 1
        @business = Business.find_by_name("Biz_#{self.id.to_s}")
        if @business == nil
          @sector = Sector.first
          @business = Business.new(:name => "Biz_#{self.id.to_s}",
        		:address => self.address,
        		:sector_id => @sector.id)
          @business.save
          @employee = Employee.new(:business_id => @business.id,
        		:user_id => self.id,
        		:officer => true)
          @employee.save
        end
      end
    end
    
    def remove_private_business
      @business = Business.find_by_name("Biz_#{self.id.to_s}")
      unless @business == nil
        @business.destroy
      end
    end
    

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

