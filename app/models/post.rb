class Post < ApplicationRecord
  validates_presence_of :content
  belongs_to :user

  has_many :likes, :dependent => :destroy
  has_many :liked_users, :through => :likes, :source => :user

  def find_like(user)
    self.likes.where( :user_id => user.id ).first
  end

  has_many :favors, :dependent => :destroy
  has_many :favor_users, :through => :favors, :source => :user

  def find_favor(user)
    self.favors.where( :user_id => user.id).first
  end

end
