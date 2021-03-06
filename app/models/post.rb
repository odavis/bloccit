class Post < ActiveRecord::Base
  attr_accessible :body, :title, :topic, :postimage, :rank
  validates :title, length: { minimum: 5 }, presence: true 
  validates :body, length: { minimum: 20 }, presence: true 
  validates :user, presence: true
  validates :topic, presence: true 

  belongs_to :user 
  belongs_to :topic

  has_many :comments, dependent: :destroy 
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  after_create :create_vote

  mount_uploader :postimage, PostImageUploader 
  
  default_scope order('rank DESC')
  scope :visible_to, lambda { |user| user ? scoped : joins(:topic).where('topics.public' => true) }

  

  def up_votes
    self.votes.where(value: 1).count
  end

  def down_votes
    self.votes.where(value: -1).count
  end

  def points
    self.votes.sum(:value).to_i 
  end

  def update_rank
    age = (self.created_at - Time.new(1970,1,1)) / 86400
    new_rank = self.points + age

    self.update_attribute(:rank, new_rank)
  end


  private

  def create_vote
    user.votes.create(value: 1, post: self)
  end

end
