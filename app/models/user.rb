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
 
  has_many :employees, :dependent => :destroy
  has_many :businesses, :through => :employees, :uniq => true
  has_one :portrait, :dependent => :destroy
  has_many :achievements, :dependent => :destroy
  has_many :characteristics, :dependent => :destroy
  has_many :favourites, :dependent => :destroy
  has_many :dislikes, :dependent => :destroy
  has_many :qualifications, :dependent => :destroy
  has_many :strengths, :dependent => :destroy
  has_many :limitations, :dependent => :destroy
  has_many :aims, :dependent => :destroy
  has_many :referees, :dependent => :destroy
  has_many :previousjobs, :dependent => :destroy
  has_many :placements, :dependent => :destroy
  has_many :jobs, :through => :placements, :uniq => true
  has_many :applications, :dependent => :destroy
  
  has_many :reviewed_sessions, :foreign_key => "reviewee_id", :class_name => "Review", :dependent => :destroy
  has_many :reviewees, :through => :reviewed_sessions
  has_many :reviewer_sessions, :foreign_key => "reviewer_id", :class_name => "Review"
  has_many :reviewers, :through => :reviewer_sessions
  
  has_many :manager_jobs, :foreign_key => "manager_id", :class_name => "Department"
  has_many :managers, :through => :manager_jobs
  has_many :deputy_jobs, :foreign_key => "deputy_id", :class_name => "Department"
  has_many :deputies, :through => :deputy_jobs
  
  has_many :invitation_issues, :foreign_key => "inviter_id", :class_name => "Invitation", :dependent => :destroy
  has_many :issued_invitations, :through => :invitation_issues
  has_many :invitation_receipts, :foreign_key => "invitee_id", :class_name => "Invitation", :dependent => :destroy
  has_many :received_invitations, :through => :invitation_receipts
  
  accepts_nested_attributes_for :placements
  
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation, :account, :terms, :latitude, :longitude, :address, :placements_attributes


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  ACCOUNT_TYPES = [
    ["Individual", 1],
    ["Jobseeker", 2],
    ["Business", 3]
   # ["Invitee", 4]
  ]
  
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end
  
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
                       	
  before_save :encrypt_password, :if => :no_businesses_yet?
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode, :if => :address_changed?
  after_save :create_portrait
  after_save :create_user_business
  before_destroy :remove_private_business

  def belongs_to_business?
    #businesses.count > 0
    businesses.includes(:employees).where("businesses.name != ? and employees.left = ?", "Biz_#{self.id}", false).count > 0
  end
  
  def single_business?
    if belongs_to_business?
      @businesses = businesses.includes(:employees).where("businesses.name != ? and employees.user_id = ? and employees.left = ?", "Biz_#{self.id}", self.id, false)
      @businesses.count == 1
    end
  end
  
  def sole_business
    self.businesses.joins(:employees).where("businesses.name != ? and employees.left = ?", "Biz_#{self.id}", false).first
  end
   
  def private_business
    @business = Business.find_by_name("Biz_#{self.id}")
  end
  
  def has_private_business?
    businesses.where("businesses.name = ?", "Biz_#{self.id}").count == 1
  end
  
  def no_business_set?
    ! has_private_business? && ! belongs_to_business?
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
  
  def current_employee_at(business)
    @employee = Employee.where("business_id = ? and user_id = ? and left = ?", business.id, self.id, false).first
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
  
  def count_referees
    self.referees.count
  end
  
  def has_referees?
    count_referees > 0
  end
  
  def max_referees?
    count_referees >= 3
  end
  
  def referees_who_commented
    self.referees.where("referees.portrait_rating != ? OR referees.remarks IS NULL", 7).count
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
        return "Employee"
      else
        return "Individual"
      end
    end
  end
  
  def no_job?
    placements.count == 0
  end
  
  def outdated_reviews
    self.reviewed_sessions.where("reviews.completed = ? and cancel = ? and created_at < ?", false, false, Date.today - 14)
  end
  
  def has_outdated_reviews?
    cnt = self.outdated_reviews.count
    cnt > 0
  end
  
  def incomplete_review(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.cancel = ? 	
    		and reviews.created_at >=? and reviews.business_id = ?", 
    		false, false, Date.today - 14, business.id).limit(1)
  end
  
  def has_incomplete_review?(business)
    cnt = self.incomplete_review(business).count
    cnt > 0
  end
  
  def incomplete_self_appraisal(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.cancel = ? 	
    		and reviews.created_at >=? and reviews.business_id = ? and reviews.review_type = ?", 
    		false, false, Date.today - 14, business.id, 1).limit(1)
  end
  
  def has_incomplete_self_appraisal?(business)
    cnt = self.incomplete_self_appraisal(business).count
    cnt > 0
  end
  
  def incomplete_external_review(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.cancel = ? 	
    		and reviews.created_at >=? and reviews.business_id = ? and reviews.review_type != ?", 
    		false, false, Date.today - 14, business.id, 1).limit(1)
  end
  
  def has_incomplete_external_review?(business)
    cnt = self.incomplete_external_review(business).count
    cnt > 0
  end
  
  def started_external_reviews(business)
    self.reviewed_sessions.where("reviews.business_id = ? and reviews.review_type = ?", business.id, 2).order("reviews.created_at DESC")
  end
  
  def completed_reviews(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.business_id = ?", true, business.id).order("reviews.completion_date DESC")
  end
  
  def has_completed_reviews?(business)
    nmbr = self.completed_reviews(business).count
    nmbr > 0
  end
  
  def last_review(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.business_id = ?", true, business.id).last
  end
  
  def no_formal_reviews?(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.review_type != ? and reviews.business_id = ?", true, 1, business.id).count == 0
  end
  
  def last_formal_review(business)
     self.reviewed_sessions.where("reviews.completed = ? and reviews.review_type != ? and reviews.business_id = ?", true, 1, business.id).last
  end
  
  def last_formal_review_started(business)
    self.reviewed_sessions.where("reviews.review_type != ? and reviews.business_id = ?", 1, business.id).last
  end
  
  def no_self_appraisals?(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.review_type = ? and reviews.business_id = ?", true, 1, business.id).count == 0
  end
  
  def last_self_appraisal(business)
    self.reviewed_sessions.where("reviews.completed = ? and reviews.review_type = ? and reviews.business_id = ?", true, 1, business.id).last
  end
  
  def formal_reviews(job)
    self.reviewed_sessions.where("reviews.job_id = ? and reviews.review_type != ? 
      and reviewer_name = ? and completed = ?", job.id, 1, nil, true).order("reviews.completion_date DESC")
  end
  
  def has_formal_reviews?(job)
    cnt = self.formal_reviews(job).count
    cnt > 0
  end
  
  def self_appraisal_due?(business)
    appraisal_due = false
    @job = Job.find(self.current_job(business))  #make sure A-Plan exists and review is possible
    if @job.plan.complete?
      if self.created_at < Time.now - 30.days
        if self.completed_reviews(business).count == 0 
          appraisal_due = true
        elsif self.last_review(business).completion_date < Time.now - 100.days
          appraisal_due = true
        end 
      end
    end
    return appraisal_due
  end
  
  def self_appraisal_overdue?(business)
    appraisal_overdue = false
    #@job = Job.find(self.current_job(business))  #make sure A-Plan exists and review is possible
    #if @job.plan.complete?                       #now cancelled so officer warned A-Plan doesn't exist
      if self.created_at < Time.now - 30.days
        if self.completed_reviews(business).count == 0
          appraisal_overdue = true
        elsif self.last_review(business).completion_date < Time.now - 114.days
          appraisal_overdue = true
        end 
      end
    #end
    return appraisal_overdue
  end
  
  def external_review_due?(business)
    review_due = false
    @job = Job.find(self.current_job(business))  #make sure A-Plan exists and review is possible
    if @job.plan.complete?
      if self.created_at < Time.now - 60.days
        #if self.completed_reviews(business).count == 0
        if self.started_external_reviews(business).count == 0
          review_due = true
        #elsif self.last_formal_review(business).completion_date < Time.now - 200.days
        elsif self.last_formal_review_started(business).created_at < Time.now - 200.days
          review_due = true
        end 
      end
    end
    return review_due
  end
  
  def external_review_overdue?(business)
    review_overdue = false
    #@job = Job.find(self.current_job(business))  #make sure A-Plan exists and review is possible
    #if @job.plan.complete?			  #now cancelled so officer warned A-Plan doesn't exist
      if self.created_at < Time.now - 60.days
        #if self.completed_reviews(business).count == 0 
        if self.started_external_reviews(business).count == 0 
          review_overdue = true
        #elsif self.last_formal_review(business).completion_date < Time.now - 214.days
        elsif self.last_formal_review_started(business).created_at < Time.now - 214.days
          review_overdue = true
        end
      end 
    #end
    return review_overdue
  end 
  
  def recent_reviewed_sessions
    self.reviewed_sessions.where("reviews.completion_date > ?", Date.today - 1.year)
  end
  
  def recent_reviewer_sessions
    self.reviewer_sessions.where("reviews.completion_date > ? and reviews.review_type = ?", Date.today - 1.year, 2).order("reviews.completion_date DESC")
  end
  
  def has_been_reviewer?
    self.recent_reviewer_sessions.count > 0
  end
  
  def involved_in_recent_reviews?
    self.recent_reviewed_sessions.count > 0 || self.recent_reviewer_sessions.count > 0
  end
  
  def review_requests(business)
    Review.where("reviewer_id = ? and review_type != ? and cancel = ? and completed = ? 
             and business_id = ? and created_at >= ? and (consent = ? or consent IS NULL)", self.id, 1, false, false, business.id, Time.now - 14.days, true)
  end
  
  def has_review_requests?(business)
    self.review_requests(business).count > 0
  end
  
  def all_review_requests
    Review.where("reviewer_id = ? and review_type != ? and cancel = ? and completed = ? 
             and created_at >= ? and (consent = ? or consent IS NULL)", self.id, 1, false, false, Time.now - 14.days, true)
  end
  
  def has_any_review_requests?
    self.all_review_requests.count > 0
  end
  
  def rejected_review_requests(business)
    Review.where("reviewer_id = ? and review_type != ? and cancel = ? and completed = ? 
             and business_id = ? and created_at >= ? and consent = ?", self.id, 1, false, false, business.id, Time.now - 14.days, false)
  end
  
  def has_rejected_review_requests?(business)
    self.rejected_review_requests(business).count > 0
  end
  
  def all_rejected_review_requests
    Review.where("reviewer_id = ? and review_type != ? and cancel = ? and completed = ? 
             and created_at >= ? and consent = ?", self.id, 1, false, false, Time.now - 14.days, false)
  end
  
  def has_any_rejected_review_requests?
    self.all_rejected_review_requests.count > 0
  end
  
  def employee_lookup(business)
    @business = Business.find(business)
    @employee = Employee.find_by_user_id_and_business_id(self.id, @business.id)
  end
  
  def current_job(business)
    self.jobs.joins(:placements).where("placements.current = ? and jobs.business_id = ?", true, business).first
  end
  
  def current_placement(business)
    @job = self.current_job(business)
    @placement = Placement.find_by_user_id_and_job_id_and_current(self.id, @job.id, true)
  end
  
  def current_department(business)
    @job = Job.find(self.current_job(business))
    @department = Department.find(@job.department_id)
  end
  
  def full_identifier(business)
    identification = "#{self.name} - #{self.current_job(business).job_title}, #{self.current_department(business).name}"
  end
  
  def active_external_jobs
    @biz = 0
    @business = Business.find_by_name("Biz_#{self.id.to_s}")
    @biz = @business.id unless @business == nil
    @active_jobs = Job.joins(:placements).where("placements.user_id = ? and placements.current = ? and jobs.business_id != ?",
                      self.id, true, @biz)
  end
  
  def deactivate_current_placement(business)
    @placement = self.current_placement(business)
    @placement.update_attribute(:current, false)
  end
  
  def no_current_job?(business)
    self.current_job(business) == nil
  end
  
  def deactivate_old_placements(placement, business)
    @old_placements = self.placements.where("placements.id != ? and placements.current =?", placement.id, true)
    @old_placements.each do |o|
      if o.job.business_id == business.id
        o.update_attribute(:current, false)
      end
    end
  end
  
  def previous_jobs(business)
    self.jobs.joins(:placements).where("placements.current = ? and jobs.business_id = ?", false, business).order("placements.started_job DESC")
  end
  
  def has_previous_jobs?(business)
    nmbr = self.previous_jobs(business).count
    nmbr > 0
  end
  
  def previous_placements
    self.placements.where("placements.current = ?", false).order("started_job DESC")  
  end
  
  def pending_invitation
    @mail = self.email
    @invitation = Invitation.find_by_email_and_signed_up(@mail, false)
  end
  
  def no_pending_invitation?
    self.pending_invitation.nil?
  end
  
  def not_an_officer?
    cnt = self.businesses.joins(:employees).where("employees.officer = ? and employees.left = ? 
                               and businesses.name != ?", true, false, "Biz_#{self.id}").count
    cnt == 0
  end
  
  def not_an_officer_this?(business)
    cnt = self.businesses.joins(:employees).where("employees.officer = ? and employees.left = ? 
                               and employees.business_id = ?", true, false, business.id).count
    cnt == 0
  end
  
  def simple_employee?(business)
    self.single_business? && self.account == 4 && self.not_an_officer_this?(business)
  end
  
  
  def self.all_active_in(department)
    self.joins(:placements).where("placements.current = ? and placements.department_id = ?", 
         true, department.id).order("users.name")
  end
  
  def self.search(search)
    if search  
      where('name LIKE ?', "%#{search}%")  
    else  
      scoped  
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
        		:officer => true, 
        		:ref_no => 1)
          @employee.save
          @department = @business.departments.build(:name => "Unknown")
          @department.save
        end
      end
    end
    
    def remove_private_business
      @business = Business.find_by_name("Biz_#{self.id.to_s}")
      unless @business == nil
        @business.destroy
      end
    end
    
    def no_businesses_yet?
      self.businesses.count == 0
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

