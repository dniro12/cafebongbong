# == Schema Information
# Schema version: 20100419135633
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :Posts
  
  attr_accessor :password ,:avatar
  attr_accessible :name, :email, :password, :password_confirmation, :avatar 
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_presence_of :name, :email
  validates_length_of   :name, :maximum => 50
  validates_format_of   :email, :with => EmailRegex
  validates_uniqueness_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password
  
  validates_presence_of :password
  validates_length_of :password, :within => 6..40
  
  #avatar Image File use for PaperClip : install needs! for styles nees for image_magic 
  has_attached_file :avatar ,
        :styles => {:thumb => "75x75>", :small => "150x150>"}, 
        :storage => :s3, 
        :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
        :path => "/:style/:filename",
        :bucket => "cafebongbong"
  
  
   
  # before_save filter
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}")
    save_without_validation
  end
  
  
  def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     return nil  if user.nil?
     return user if user.has_password?(submitted_password)
   end
   

  
  private
  def encrypt_password
     unless password.nil?
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end
