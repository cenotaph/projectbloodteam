# -*- encoding : utf-8 -*-
class Agent < ActiveRecord::Base
  has_many :views
  has_many :categories
  has_many :labels
  belongs_to :theme
  has_many :profiles
  has_many :favoritemovies
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :encryptable, :encryptor => :md5
  attr_accessor :login
  has_many :entries
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  # scopes
  scope :active, -> { where(:active => true) }
  
  # Virtual attribute for the unencrypted password
  attr_accessor :plain_password, :new_user_password
  # validates_presence_of   :imageurl
  validates_presence_of     :username
  validates_presence_of     :email, :on  => :create, :if => :email_required?
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?, :on => :create
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :username,    :within => 3..40
  validates_length_of       :email,    :within => 3..100, :on  => :create, :if => :email_required?
  validates_uniqueness_of   :username, :email, :case_sensitive => false, :on => :create
  
  # before_create :encrypt_password, :check_new_user_password, :set_remember_token
 
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def slug_candidates
    [
      :surname,
      [:surname, :id]
    ]
  end
  
  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end
  
  def self.active_menu
    active = Profile.includes(:agent).where(:year => Time.now.strftime('%Y')).map{|x| x.agent}.sort_by{|x| x.surname.downcase}.map{|x| [x.surname, x.id]}
    inactive = Agent.all.to_a.delete_if{|x| active.map{|y| y.last}.include?(x.id)}.sort_by{|x| x.surname.downcase }.map{|x| [x.surname, x.id]}
    return active + [' -- inactive -- '] + inactive
  end 
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  #attr_accessible :username, :email, :password, :plain_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, pword)
  
    u = find_by_username_and_active(login, true)
    u && u.authenticated?(pword) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(pword)
    Digest::MD5.hexdigest(pword)
  end

  
  # Encrypts the password with the user salt
  def encrypt(pword)
    self.class.encrypt(pword)
  end

  def authenticated?(pword)

    password == encrypt(pword)
  end



  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def agent_icon(style = '')
    p = Profile.where(:agent_id => self.id).where(:year => Time.now.strftime('%Y')).first
    if p.nil?
      '/img/anonymous.gif'
    else
      unless p.avatar_file_size.nil?
        if p.avatar_file_size > 0 
          p.avatar.url(style)
        else
        '/img/anonymous.gif'
        end
      else
        '/img/anonymous.gif'
      end
    end
  end
  
 # my methods, specific to PBT
  def icon(year= nil)
    if year.nil?
     if self.imageurl.blank?
       return "/images/anonymous.gif"
     else
       return self.imageurl
     end
    else
      if self.profiles.yearly(year).first.nil?
        return "/images/anonymous.gif"
      elsif self.profiles.yearly(year).first.imageurl.blank?
        return self.imageurl
      else
        return self.profiles.yearly(year).first.imageurl
      end
    end
  end
  
  def profile(year = Time.now.strftime('%Y'))
    Profile.where(:agent_id => self.id).where(:year => year).first
  end
  
  def years
    self.profiles.collect{|x| x.year}.sort{|x,y| y<=> x}
  end
  
  def default_currency
    p = Profile.where(:agent_id => id).where(:year => Time.now.strftime('%Y')).first
    p.nil? ? 1 : p.defaultcurrency_id
    # Currency.where(:symbol => self.defaultcurrency).first.id
  end
  

      
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
    #  self.salt = Digest::MD5.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
      self.password = encrypt(password_confirmation)
    end
      
    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    def email_required?
      false
    end
      
    
    def check_new_user_password
      if new_user_password == "norman_reedus"
        active = true
      else
        return false
      end
    end
    
    def set_remember_token
      remember_token_expires_at = Time.now.utc
      remember_token     = encrypt("#{username}--#{remember_token_expires_at}")
    end

end
