require 'digest/md5'
class Channel < ActiveRecord::Base
  
  validates_presence_of :name
  
  before_create :generate_uid
  
  protected
  
  def generate_uid
    self.uid ||= Digest::MD5.hexdigest( rand(1000000).to_s + Time.now.to_s )[0,12]
  end
  
end
